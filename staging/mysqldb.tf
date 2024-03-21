# MySQL Database Setup
resource "aws_db_subnet_group" "db_subnets" {
  name       = "housing-finance-db-subnet-${var.environment_name}"
  subnet_ids = ["subnet-0743d86e9b362fa38","subnet-0ea0020a44b98a2ca"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "housing-mysql-db" {
  identifier                  = "housing-finance-db-${var.environment_name}"
  engine                      = "mysql"
  engine_version              = "8.0.35"
  instance_class              = "db.t2.micro" //this should be a more production appropriate instance in production
  allocated_storage           = 10
  storage_type                = "gp2" //ssd
  port                        = 3306
  backup_window               = "00:01-00:31"
  username                    = data.aws_ssm_parameter.housing_finance_mysql_username.value
  password                    = data.aws_ssm_parameter.housing_finance_mysql_password.value
  vpc_security_group_ids      = [aws_security_group.mtfh_finance_security_group.id]
  db_subnet_group_name        = aws_db_subnet_group.db_subnets.name
  db_name                        = data.aws_ssm_parameter.housing_finance_mysql_database.value
  monitoring_interval         = 0 //this is for enhanced Monitoring there will already be some basic monitoring available
  backup_retention_period     = 30
  storage_encrypted           = false  //this should be true for production
  deletion_protection         = false
  multi_az                    = false //this should be true for production
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  apply_immediately   = false
  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Name              = "housing-finance-db-${var.environment_name}"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
  }
}

resource "aws_db_instance" "housing-mysql-db-replica" {
  identifier                  = "housing-finance-db-${var.environment_name}-replica"
  replicate_source_db         = aws_db_instance.housing-mysql-db.id
  instance_class              = "db.t2.micro" //this should be a more production appropriate instance in production
  allocated_storage           = 10
  storage_type                = "gp2" //ssd
  port                        = 3306
  backup_window               = "00:01-00:31"
  vpc_security_group_ids      = [aws_security_group.mtfh_finance_security_group.id]
  monitoring_interval         = 0 //this is for enhanced Monitoring there will already be some basic monitoring available
  backup_retention_period     = 30
  storage_encrypted           = false  //this should be true for production
  deletion_protection         = false
  multi_az                    = false //this should be true for production
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  apply_immediately   = false
  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Name              = "housing-finance-db-${var.environment_name}-replica"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
  }
}
