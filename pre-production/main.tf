provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket         = "housing-pre-production-terraform-state"
    encrypt        = true
    region         = "eu-west-2"
    key            = "services/mtfh-finance-infrastructure/state"
    dynamodb_table = "housing-pre-production-terraform-state-lock"
  }
}

resource "aws_security_group" "mtfh_finance_security_group" {
  name        = "mtfh-finance-allow-traffic-${var.environment_name}"
  description = "Allow traffic for the various databases and applications"
  vpc_id      = "vpc-062a957b99c8b12e6"

  ingress {
    description = "Allow Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mtfh_finance_allow_db_traffic"
  }
}
