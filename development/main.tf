provider "aws" {
  region  = "eu-west-2"
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
    service_name = "mtfh-finance"
    parameter_store = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter"
}


# Terraform State Management
terraform {
  backend "s3" {
    bucket  = "terraform-state-housing-development"
    encrypt = true
    region  = "eu-west-2"
    key     = "services/mtfh-finance-infrastructure/state"
  }
}

data "aws_ssm_parameter" "housing_finance_postgres_database" {
  name = "/housing-finance/development/postgres-database"
}
data "aws_ssm_parameter" "housing_finance_postgres_port" {
  name = "/housing-finance/development/postgres-port"
}
data "aws_ssm_parameter" "housing_finance_postgres_username" {
  name = "/housing-finance/development/postgres-username"
}
data "aws_ssm_parameter" "housing_finance_postgres_password" {
  name = "/housing-finance/development/postgres-password"
}
data "aws_ssm_parameter" "housing_finance_mssql_database" {
  name = "/housing-finance/development/mssql-database"
}
data "aws_ssm_parameter" "housing_finance_mssql_username" {
  name = "/housing-finance/development/mssql-username"
}
data "aws_ssm_parameter" "housing_finance_mssql_password" {
  name = "/housing-finance/development/mssql-password"
}

resource "aws_security_group" "mtfh_finance_security_group" {
  name        = "mtfh-finance-allow-traffic-${var.environment_name}"
  description = "Allow traffic for the various databases and applications"
  vpc_id      = "vpc-0d15f152935c8716f"

  ingress {
    description      = "Allow Postgres"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mtfh_finance_allow_db_traffic"
  }
}

# module "civicapay_cashfile_sync" {
#   source                    = "../civicapay_cashfile_sync_module"
#   environment               = var.environment_name
#   remote_lambda_role_arn    = var.remote_lambda_role_arn
#   statemachine_lambda_name  = var.statemachine_lambda_name
#   statemachine_lambda_role  = var.statemachine_lambda_role
# }