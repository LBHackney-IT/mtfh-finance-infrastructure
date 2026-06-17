# Task Role IAM Policy doc
terraform {
  backend "s3" {
    bucket  = "terraform-state-housing-staging"
    encrypt = true
    region  = "eu-west-2"
    key     = "services/mtfh-finance-infrastructure/hfs-nightly-charges/state"
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "hfs_nightly_charges_task_role" {

  # Cloudwatch Logs full access
  statement {
    effect = "Allow"
    actions = [
      "logs:*"
    ]
    resources = ["*"]
  }

  # SSM Read Only Access
  statement {
    effect = "Allow"
    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*"
    ]
    resources = ["*"]
  }

  # SNS Read Only Access and Publish
  statement {
    effect = "Allow"
    actions = [
      "sns:Get*",
      "sns:List*",
      "sns:Subscribe",
      "sns:Publish"
    ]
    resources = ["*"]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "workers" {
  name = "${var.operation_name}-cluster-${var.environment}"

  tags = {
    "Process" = "Housing Finance"
    "Domain"  = "HFS Nightly Jobs"
  }
}

# Assign a dedicated Security Group
resource "aws_security_group" "hfs_nightly_jobs" {
  name        = "${var.operation_name}-sg-${var.environment}"
  description = "Allow traffic to MSSQL HFS database"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow inbound traffic to MSSQL RDS"
    from_port        = 1433
    to_port          = 1433
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SNS topic for overnight process errors
resource "aws_sns_topic" "housing_finance_alarms" {
  name = "housing-finance-alarms"
}

import {
  to = aws_sns_topic.housing_finance_alarms
  id = "arn:aws:sns:eu-west-2:${data.aws_caller_identity.current.account_id}:housing-finance-alarms"
}

data "aws_security_group" "hfs_nightly_jobs_sg" {
  filter {
    name   = "group-name"
    values = ["${var.operation_name}-sg-${var.environment}"]
  }
}

import {
  to = aws_security_group.hfs_nightly_jobs
  id = data.aws_security_group.hfs_nightly_jobs_sg.id
}

import {
  to = aws_ecs_cluster.workers
  id = "${var.operation_name}-cluster-${var.environment}"
}

import {
  to = module.hfs-nightly-charges.aws_iam_role.fargate
  id = "${var.operation_name}-fargate"
}

import {
  to = module.hfs-nightly-charges.aws_iam_role.task_role
  id = "${var.operation_name}-task-role"
}

import {
  to = module.hfs-nightly-charges.aws_iam_role.cloudwatch_run_ecs_events
  id = "${var.operation_name}-cloudwatch-role"
}

import {
  to = module.hfs-nightly-charges.aws_ecr_repository.worker
  id = var.operation_name
}

import {
  to = module.hfs-nightly-charges.aws_cloudwatch_log_group.ecs_task_logs
  id = "${var.operation_name}-ecs-task-logs"
}

# Using the Fargate Task module
module "hfs-nightly-charges" {
  source = "../../aws_ecs_fargate_task_module"

  tags = {
    "Process"   = "Housing Finance"
    "Domain"    = "HFS Nightly Jobs"
    "Operation" = "A scheduled Fargate container which runs the HfsChargesContainer application to process HFS Charges"
  }
  operation_name                = var.operation_name
  ecs_task_role_policy_document = data.aws_iam_policy_document.hfs_nightly_charges_task_role.json
  aws_subnet_ids                = var.aws_subnet_ids
  ecs_cluster_arn               = aws_ecs_cluster.workers.arn

  tasks = [
    {
      task_prefix = "charges-ingest-task-defintion"
      task_cpu    = 256
      task_memory = 512
      environment_variables = [
        { name = "ENVIRONMENT", value = "${var.environment}" },
        { name = "SNS_TOPIC_ARN", value = aws_sns_topic.housing_finance_alarms.arn }
      ]

      cloudwatch_rule_schedule_expression = var.charges_cron_expression
      cloudwatch_rule_event_pattern       = null
      is_enabled                          = var.charges_schedule_enabled
    }
  ]

  # Using the custom security groups created above
  security_groups = [aws_security_group.hfs_nightly_jobs.id]
}