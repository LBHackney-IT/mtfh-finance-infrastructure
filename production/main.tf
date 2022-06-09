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
    bucket  = "terraform-state-housing-production"
    encrypt = true
    region  = "eu-west-2"
    key     = "services/mtfh-finance-infrastructure/state"
  }
}

data "aws_ssm_parameter" "housing_finance_postgres_database" {
  name = "/housing-finance/production/postgres-database"
}
data "aws_ssm_parameter" "housing_finance_postgres_port" {
  name = "/housing-finance/production/postgres-port"
}
data "aws_ssm_parameter" "housing_finance_postgres_username" {
  name = "/housing-finance/production/postgres-username"
}
data "aws_ssm_parameter" "housing_finance_postgres_password" {
  name = "/housing-finance/production/postgres-password"
}

data "aws_ssm_parameter" "housing_finance_mysql_database" {
  name = "/housing-finance/production/mysql-database"
}
data "aws_ssm_parameter" "housing_finance_mysql_username" {
  name = "/housing-finance/production/mysql-username"
}
data "aws_ssm_parameter" "housing_finance_mysql_password" {
  name = "/housing-finance/production/mysql-password"
}
data "aws_ssm_parameter" "housing_finance_mssql_username" {
  name = "/housing-finance/production/mssql-username"
}
data "aws_ssm_parameter" "housing_finance_mssql_password" {
  name = "/housing-finance/production/mssql-password"
}

resource "aws_security_group" "mtfh_finance_security_group" {
  name        = "mtfh-finance-allowdb-traffic-${var.environment_name}"
  description = "Allow traffic for the various database types"
  vpc_id      = "vpc-0ce853ddb64e8fb3c"

  ingress {
    description      = "Allow MySql"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow MsSql"
    from_port        = 1433
    to_port          = 1433
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow Redis"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "Allow traffic for income api"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "Allow traffic for manage arrears front end"
    from_port        = 3001
    to_port          = 3001
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mtfh_finance_allow_db_traffic"
  }
}