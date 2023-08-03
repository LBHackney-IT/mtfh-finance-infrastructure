# provider "aws" {
#   region = "eu-west-2"
# }
# data "aws_caller_identity" "current" {}
# data "aws_region" "current" {}
# locals {
#     service_name = "mtfh-finance"
#     parameter_store = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter"
# }

data "aws_ssm_parameter" "housing_finance_mssql_database" {
  name = "/housing-finance/development/mssql-database"
}
data "aws_ssm_parameter" "housing_finance_mssql_username" {
  name = "/housing-finance/development/mssql-username"
}
data "aws_ssm_parameter" "housing_finance_mssql_password" {
  name = "/housing-finance/development/mssql-password"
}

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

resource "aws_ecs_cluster" "workers" {
  tags = {
    "Process" = "Housing Finance"
    "Domain" = "HFS Nightly Jobs"
  }
  # name = "${var.operation_name}"
  name = "hfs-nightly-jobs-charges-ingest-tf"
}


module "hfs-nightly-charges" {
  source = "../aws_ecs_fargate_task_module"

  tags = {
    "tag1" = "value1"
    "tag2" = "value2"
  }
  operation_name                = "hfs-nightly-jobs-charges-ingest-tf"
  ecs_task_role_policy_document = data.aws_iam_policy_document.hfs_nightly_charges_task_role.json
  aws_subnet_ids                = ["subnet-05ce390ba88c42bfd", "subnet-0140d06fb84fdb547"]
  ecs_cluster_arn               = aws_ecs_cluster.workers.arn

  tasks = [
    {
      task_prefix = "charges-ingest-task01"
      task_cpu    = 256
      task_memory = 512
      environment_variables = [
        { name = "dbName", value = data.aws_ssm_parameter.housing_finance_mssql_database.value },
        { name = "dbUser", value = data.aws_ssm_parameter.housing_finance_mssql_username.value },
        { name = "dbPassword", value = data.aws_ssm_parameter.housing_finance_mssql_password.value }
      ]
      # <-- Change to correct cron expression for nightly runs
      cloudwatch_rule_schedule_expression = "cron(0/5 * ? * MON-FRI *)"
      cloudwatch_rule_event_pattern       = null
    }
  ]
  security_groups = ["sg-00d2e14f38245dd0b"]
}
