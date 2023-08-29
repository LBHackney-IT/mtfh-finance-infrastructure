# Task Role IAM Policy doc
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add a Security Group Rule for MSSQL inbound traffic
resource "aws_security_group_rule" "inbound_traffic_to_mssql" {
  description       = "Allow inbound traffic to MSSQL RDS"
  security_group_id = aws_security_group.hfs_nightly_jobs.id
  protocol          = "TCP"
  from_port         = 1433
  to_port           = 1433
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

# Create an SNS Topic. There should only be a single Topic for HFS Nightly Jobs - per environment (reuse this for any future Fargate process)
resource "aws_sns_topic" "sns_alarms" {
  name = "hfs-nightly-jobs-alarms-${var.environment}"
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
        { name = "SNS_TOPIC_ARN", value = aws_sns_topic.sns_alarms.arn }
      ]

      cloudwatch_rule_schedule_expression = var.charges_cron_expression
      cloudwatch_rule_event_pattern       = null
    }
  ]

  # Using the custom security group created above
  security_groups = [aws_security_group.hfs_nightly_jobs.id]
}