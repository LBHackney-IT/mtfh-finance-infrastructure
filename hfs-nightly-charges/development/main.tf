


data "aws_ssm_parameter" "housing_finance_mssql_dbhost" {
  name = "/housing-finance/development/db-host"
}
data "aws_ssm_parameter" "housing_finance_mssql_database" {
  name = "/housing-finance/development/mssql-database"
}
data "aws_ssm_parameter" "housing_finance_mssql_username" {
  name = "/housing-finance/development/mssql-username"
}
data "aws_ssm_parameter" "housing_finance_mssql_password" {
  name = "/housing-finance/development/db-password"
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

# Using the Fargate Task module
module "hfs-nightly-charges" {
  source = "../../aws_ecs_fargate_task_module"

  tags = {
    "tag1" = "value1"
    "tag2" = "value2"
  }
  operation_name                = "${var.operation_name}"
  ecs_task_role_policy_document = data.aws_iam_policy_document.hfs_nightly_charges_task_role.json
  aws_subnet_ids = [
      "subnet-05ce390ba88c42bfd",
      "subnet-0140d06fb84fdb547"]
  ecs_cluster_arn = aws_ecs_cluster.workers.arn

  tasks = [
    {
      task_prefix = "charges-ingest-task01"
      task_cpu    = 256
      task_memory = 512
      environment_variables = [
        { name = "DB_HOST", value = data.aws_ssm_parameter.housing_finance_mssql_dbhost.value },
        { name = "DB_NAME", value = data.aws_ssm_parameter.housing_finance_mssql_database.value },
        { name = "DB_USER", value = data.aws_ssm_parameter.housing_finance_mssql_username.value },
        { name = "DB_PASSWORD", value = data.aws_ssm_parameter.housing_finance_mssql_password.value }
      ]

      cloudwatch_rule_schedule_expression = "cron(30 0 * * ? *)"
      cloudwatch_rule_event_pattern       = null
    }
  ]
  security_groups = ["sg-00d2e14f38245dd0b"]
}