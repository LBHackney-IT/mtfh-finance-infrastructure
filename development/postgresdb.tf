# Postg Database Setup

resource "aws_db_instance" "postgres_db_development" {
  environment_name = "development"
  vpc_id =  "vpc-0d15f152935c8716f"
  db_engine = "postgres"
  db_engine_version = "12.14"
  db_identifier = "mtfh-finance-pgdb"
  db_instance_class = "db.t3.micro"
  db_name = data.aws_ssm_parameter.housing_finance_postgres_database.value
  db_port  = data.aws_ssm_parameter.housing_finance_postgres_port.value
  db_username = data.aws_ssm_parameter.housing_finance_postgres_username.value
  db_password = data.aws_ssm_parameter.housing_finance_postgres_password.value
  subnet_ids = ["subnet-05ce390ba88c42bfd","subnet-0140d06fb84fdb547"]
  db_allocated_storage = 20
  maintenance_window ="sun:10:00-sun:10:30"
  storage_encrypted = false
  multi_az = false //only true if production deployment
  publicly_accessible = false
  project_name = "housing finance"

  storage_type                = "gp2" //ssd
  backup_window               = "00:01-00:31"
  monitoring_interval         = 0 //this is for enhanced Monitoring there will allready be some basic monitering avalable
  backup_retention_period     = 30
  deletion_protection         = false
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  apply_immediately   = false
  skip_final_snapshot = true

  tags = {
    Name              = "${data.aws_ssm_parameter.housing_finance_postgres_database.value}-db-development"
    Environment       = "development"
    terraform-managed = true
    project_name      = var.project_name
  }
}