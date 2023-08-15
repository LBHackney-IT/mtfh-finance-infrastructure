locals {
  ssm_path = "${var.housing_finance_prefix}/${var.environment}"
}

# Environment variables for the Task
data "aws_ssm_parameter" "housing_finance_mssql_dbhost" {
  name = "${local.ssm_path}/db-host"
}
data "aws_ssm_parameter" "housing_finance_mssql_database" {
  name = "${local.ssm_path}/mssql-database"
}
data "aws_ssm_parameter" "housing_finance_mssql_username" {
  name = "${local.ssm_path}/mssql-username"
}
data "aws_ssm_parameter" "housing_finance_mssql_password" {
  name = "${local.ssm_path}/db-password"
}
data "aws_ssm_parameter" "google_api_key" {
  name = "${local.ssm_path}/google-application-credentials-json"
}
data "aws_ssm_parameter" "charges_batch_years" {
  name = "${local.ssm_path}/charges-batch-years"
}
data "aws_ssm_parameter" "batch_size" {
  name = "${local.ssm_path}/bulk-insert-batch-size"
}

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
  vpc_id      = "vpc-0d15f152935c8716f"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add a Security Group Rule for MSSQL outgoing traffic
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
  aws_subnet_ids                = ["subnet-05ce390ba88c42bfd", "subnet-0140d06fb84fdb547"]
  ecs_cluster_arn               = aws_ecs_cluster.workers.arn

  tasks = [
    {
      task_prefix = "charges-ingest-task-defintion"
      task_cpu    = 256
      task_memory = 512
      environment_variables = [
        { name = "DB_HOST", value = data.aws_ssm_parameter.housing_finance_mssql_dbhost.value },
        { name = "DB_NAME", value = data.aws_ssm_parameter.housing_finance_mssql_database.value },
        { name = "DB_USER", value = data.aws_ssm_parameter.housing_finance_mssql_username.value },
        { name = "DB_PASSWORD", value = data.aws_ssm_parameter.housing_finance_mssql_password.value },
        { name = "GOOGLE_API_KEY", value = data.aws_ssm_parameter.google_api_key.value },
        { name = "CHARGES_BATCH_YEARS", value = data.aws_ssm_parameter.charges_batch_years.value },
        { name = "BATCH_SIZE", value = data.aws_ssm_parameter.batch_size.value }
      ]

      cloudwatch_rule_schedule_expression = "cron(30 0 * * ? *)"
      cloudwatch_rule_event_pattern       = null
    }
  ]

  #   security_groups = ["sg-00d2e14f38245dd0b"]
  security_groups = [aws_security_group.hfs_nightly_jobs.id]
}