# Postg Database Setup
module "db_security_group" {
  source           = "github.com/LBHackney-IT/aws-hackney-common-terraform.git//modules/security_groups/database/internal_only_traffic"
  vpc_id           = "vpc-0d15f152935c8716f"
  db_name          = data.aws_ssm_parameter.housing_finance_postgres_database.value
  db_port          = data.aws_ssm_parameter.housing_finance_postgres_port.value
  environment_name = "development"
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "${data.aws_ssm_parameter.housing_finance_postgres_database.value}-db-subnet-development"
  subnet_ids =  ["subnet-05ce390ba88c42bfd","subnet-0140d06fb84fdb547"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "lbh-db" {
  engine = "postgres"
  engine_version = "12.17"
  identifier = "mtfh-finance-pgdb-db-development"
  instance_class = "db.t3.micro"
  db_name = data.aws_ssm_parameter.housing_finance_postgres_database.value
  port  = data.aws_ssm_parameter.housing_finance_postgres_port.value
  username = data.aws_ssm_parameter.housing_finance_postgres_username.value
  password = data.aws_ssm_parameter.housing_finance_postgres_password.value
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  allocated_storage = 20
  maintenance_window ="sun:10:00-sun:10:30"
  storage_encrypted = true
  multi_az = false //only true if production deployment

  storage_type                = "gp2" //ssd
  backup_window               = "00:01-00:31"
  monitoring_interval         = 0 //this is for enhanced Monitoring there will allready be some basic monitering avalable
  backup_retention_period     = 30
  deletion_protection         = false
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  apply_immediately   = false
  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Name              = "${data.aws_ssm_parameter.housing_finance_postgres_database.value}-db-development"
    Environment       = "development"
    terraform-managed = true
    project_name      = "housing finance"
  }
}