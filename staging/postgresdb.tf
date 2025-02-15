# Postg Database Setup

# Propref - Paymentref link database
module "postgres_db_staging" {
  source = "../modules/postgres"
  environment_name = "staging"
  vpc_id =  "vpc-064521a7a4109ba31"
  db_engine = "postgres"
  db_engine_version = "16.3"
  db_parameter_group_name = "postgres16"
  db_identifier = "mtfh-finance-pgdb"
  db_instance_class = "db.t3.micro"
  db_name = data.aws_ssm_parameter.housing_finance_postgres_database.value
  db_port  = data.aws_ssm_parameter.housing_finance_postgres_port.value
  db_username = data.aws_ssm_parameter.housing_finance_postgres_username.value
  db_password = data.aws_ssm_parameter.housing_finance_postgres_password.value
  subnet_ids = ["subnet-0743d86e9b362fa38","subnet-0ea0020a44b98a2ca"]
  db_allocated_storage = 20
  maintenance_window = "sat:10:00-sat:10:30"
  backup_window = "00:01-00:31"
  storage_encrypted = false
  multi_az = false //only true if production deployment
  publicly_accessible = false
  project_name = "housing finance"
  vpc_security_group_ids = ["sg-073e2b36118911fc4"]
}