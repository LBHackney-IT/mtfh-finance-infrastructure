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

module "civica_sftp_filesync" {
  source = "../civica_sftp_filesync_module"
  environment = var.environment_name
  statemachine_lambda_name = var.statemachine_lambda_name
  statemachine_lambda_role = var.statemachine_lambda_role
  sftp_user_name = "civica.ifs" #module.civica_sftp_filesync.civica_sftp_username
  sftp_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBbItKs2WMU7Z5UCh8kUeY8lzlUwP7CoTc4IlhpWV6v2AgVwPziDz1iywKR5GAkUO0f0GNwl3EQMy9HYzYgr+1/Bk2mAtIqaH4zGgJtVGNEweguB54V6ntFhGPlDs1DWws64vzqTWa7PJpI6RqH16hQDGKYPnMlKHhr4H6+nepd/0+aRsTV44ATbLdaqRbPmHLd3s7sLk6Sriwr++1S9z3S/0SKF8JKQlUfYNWXNz0uea8qB0plj6/Njljgm7cixXL9AfDI0c0Cbk48j9C4wiOC6aP6Eiakmk5+pimzhlmWi4z1ZZhWHHhevhSZTLaiT6QKP+At8frZ94I6waNJozNyodzxdV75lLtWb3uonSkseIhC2qvXZe1I9HA9DeeXJ63+4IxE21EA15kc7jRKD6VufrF9UpSSA/WbYRgkOcwxy+SBsJy6pjvh6msAmTO2n4liWJqu1UF9s0IKYOtY8ph8KlNuJdAEPAxCORLeRCUO82+Hqt5U41fSyZtpMMV0ok=" 
  #module.civica_sftp_filesync.civica_sftp_public_key
}