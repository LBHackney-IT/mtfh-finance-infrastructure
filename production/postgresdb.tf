# Postg Database Setup

# Propref - Paymentref link database
module "postgres_db_production" {
  source = "../modules/postgres"
  environment_name = "production"
  vpc_id =  "vpc-0ce853ddb64e8fb3c"
  db_engine = "postgres"
  db_engine_version = "16.3"
  db_identifier = "mtfh-finance-pgdb"
  db_instance_class = "db.t3.large"
  db_name = data.aws_ssm_parameter.housing_finance_postgres_database.value
  db_port  = data.aws_ssm_parameter.housing_finance_postgres_port.value
  db_username = data.aws_ssm_parameter.housing_finance_postgres_username.value
  db_password = data.aws_ssm_parameter.housing_finance_postgres_password.value
  subnet_ids = ["subnet-0beb266003a56ca82","subnet-06a697d86a9b6ed01"]
  db_allocated_storage = 100
  maintenance_window ="sun:10:00-sun:10:30"
  backup_window = "00:01-00:31"
  storage_encrypted = true
  multi_az = true //only true if production deployment
  publicly_accessible = false
  project_name = "housing finance"
  backup_policy = "Prod"
  vpc_security_group_ids = ["sg-07d40f16ad18f1f60"]
}