# Postg Database Setup

# Propref - Paymentref link database
module "postgres_db_production" {
  source = "../modules/postgres"
  environment_name = "production"
  vpc_id =  "vpc-006989d0b2bb070d9"
  db_engine = "postgres"
  db_engine_version = "16.8"
  db_parameter_group_name = "postgres16"
  db_identifier = "uh-mirror"
  db_instance_class = "db.t3.medium"
  db_name = "uh_mirror"
  db_port  = 5300
  db_username = data.aws_ssm_parameter.housing_finance_postgres_username.value
  db_password = data.aws_ssm_parameter.housing_finance_postgres_password.value
  subnet_ids = ["subnet-05e595c59b7d6c8df","subnet-0e6bc9b4ac24493cc"]
  db_allocated_storage = 20
  maintenance_window ="sun:10:00-sun:10:30"
  backup_window = "00:01-00:31"
  storage_encrypted = true
  multi_az = true //only true if production deployment
  publicly_accessible = false
  project_name = "housing finance"
  backup_policy = "Prod"
  vpc_security_group_ids = ["sg-0de9adcce8b43b894"]
}