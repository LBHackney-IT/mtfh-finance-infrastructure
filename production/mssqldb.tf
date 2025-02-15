# MS SQL Server DB Setup (no common resource)
resource "aws_db_subnet_group" "mssql_db_subnets" {
  name       = "housing-finance-mssql-db-subnet-${var.environment_name}"
  subnet_ids = ["subnet-0beb266003a56ca82","subnet-06a697d86a9b6ed01"]
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_db_instance" "mssql-ee" {
  allocated_storage       = 2500
  max_allocated_storage   = 3000
  engine                  = "sqlserver-ee"
  engine_version          = "15.00.4198.2.v1"
  instance_class          = "db.t3.xlarge"
  license_model           = "license-included"
  identifier              = "${var.mssql-db-target}-${var.environment_name}"
  username                = data.aws_ssm_parameter.housing_finance_mssql_username.value
  password                = data.aws_ssm_parameter.housing_finance_mssql_password.value
  vpc_security_group_ids  = [aws_security_group.mtfh_finance_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.mssql_db_subnets.name
  multi_az                = true
  publicly_accessible     = false
  backup_retention_period = 30
  storage_encrypted       = true
  deletion_protection     = true
  apply_immediately       = false
  skip_final_snapshot     = true
  performance_insights_enabled = true

  maintenance_window      = "Sun:10:00-Sun:12:00"
  backup_window           = "22:30-23:30"

  tags = {
    Name              = "${var.mssql-db-target}-${var.environment_name}"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
    BackupPolicy      = "Prod"
  }

  tags_all = {
    BackupPolicy      = "Prod"
  }

  lifecycle {
    prevent_destroy   = true
    ignore_changes    = [
      storage_encrypted
    ]
  }  
}

# create a read replica database from the EE instance
resource "aws_db_instance" "db_ee_replica" {
  allocated_storage   = 45
  max_allocated_storage = 1200
  instance_class      = "db.t3.xlarge"
  apply_immediately = false

  #name
  identifier          = "${var.mssql-db-target}-${var.environment_name}-replica"
  skip_final_snapshot = true

  replicate_source_db = aws_db_instance.mssql-ee.identifier

  maintenance_window      = "Sun:10:00-Sun:12:00"

  tags = {
    Name              = "${var.mssql-db-target}-${var.environment_name}-replica"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
    BackupPolicy      = "Prod"
  }

  tags_all = {
    BackupPolicy      = "Prod"
  }

  lifecycle {
    prevent_destroy   = true
    ignore_changes    = [
      storage_encrypted,
      allocated_storage,
      deletion_protection
    ]
  }  
}