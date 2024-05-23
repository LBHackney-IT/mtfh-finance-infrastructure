data "aws_ssm_parameter" "db_username" {
  name = "/housing-finance/development/db-username"
}
data "aws_ssm_parameter" "db_password" {
  name = "/housing-finance/development/db-password"
}

# HFS Postgres Master database
module "postgres_db_master" {
  source               = "../modules/postgres"
  environment_name     = var.environment_name
  db_identifier        = "housing-finance-master"
  db_engine            = "postgres"
  db_engine_version    = "16.1"
  db_instance_class    = "db.t3.xlarge"
  db_name              = "hfs-postgres-master"
  # TODO: Replace these with a parameter group
  db_username          = data.aws_ssm_parameter.db_username.value
  db_password          = data.aws_ssm_parameter.db_password.value
  vpc_id               = "vpc-0d15f152935c8716f"
  db_allocated_storage = 1200
  db_port              = "5432"
  subnet_ids           = ["subnet-05ce390ba88c42bfd","subnet-0140d06fb84fdb547"]
  storage_encrypted    = true
  multi_az             = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
  maintenance_window   = "tue:01:00-tue:03:00"
  backup_window        = "08:45-09:15"
  publicly_accessible  = false
  project_name         = "Housing-Finance PostgreSQL master database"
  backup_policy        = "Dev"
  vpc_security_group_ids = ["sg-05ce2e123157570b5"] # mtfh-finance-allow-traffic-development
}