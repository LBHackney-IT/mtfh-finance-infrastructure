locals {
  additional_tags = { Confidentiality = "Internal", Application = "MTFH Housing Pre-Production", TeamEmail = "developementteam@hackney.gov.uk" }
}

# Postg Database Setup

# Propref - Paymentref link database
module "postgres_db_pre_production" {
  source                          = "../modules/postgres"
  environment_name                = var.environment_name
  vpc_id                          = "vpc-062a957b99c8b12e6"
  db_engine                       = "postgres"
  db_engine_version               = "16.3"
  db_parameter_group_name         = "default.postgres16"
  db_identifier                   = "mtfh-finance-pgdb"
  db_instance_class               = "db.t3.micro"
  db_name                         = data.aws_ssm_parameter.housing_finance_postgres_database.value
  db_port                         = data.aws_ssm_parameter.housing_finance_postgres_port.value
  db_username                     = data.aws_ssm_parameter.housing_finance_postgres_username.value
  db_password                     = data.aws_ssm_parameter.housing_finance_postgres_password.value
  subnet_ids                      = ["subnet-08aa35159a8706faa", "subnet-0b848c5b14f841dfb"]
  db_allocated_storage            = 20
  maintenance_window              = "sun:10:00-sun:10:30"
  backup_window                   = "00:01-00:31"
  storage_encrypted               = true
  multi_az                        = false //only true if production deployment
  enabled_cloudwatch_logs_exports = ["postgresql"]
  publicly_accessible             = false
  project_name                    = "Housing-Pre-Production"
  vpc_security_group_ids          = [aws_security_group.mtfh_finance_security_group.id] // mtfh-finance-allow-traffic-pre-prod
  backup_policy                   = "Dev"
  additional_tags                 = local.additional_tags
}
