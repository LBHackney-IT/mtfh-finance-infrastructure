# MS SQL Server DB Setup (no common resource)
resource "aws_db_subnet_group" "mssql_db_subnets" {
  name       = "housing-finance-mssql-db-subnet-${var.environment_name}"
  subnet_ids = ["subnet-0ea0020a44b98a2ca","subnet-0743d86e9b362fa38"]
  lifecycle {
    create_before_destroy = true
  }
}

# identifier for the Source database
data "aws_db_instance" "source_db" {
  db_instance_identifier = "${var.mssql-db-source}-${var.environment_name}"
}

# Snapshot1 - create a snapshot of the Source DB
resource "aws_db_snapshot" "db1_snapshot" {
  db_instance_identifier = data.aws_db_instance.source_db.id
  db_snapshot_identifier = "${var.mssql-db-target}-snapshot"
}

# use Snapshot1 to create a database with EE instance
resource "aws_db_instance" "mssql-ee" {
  snapshot_identifier = aws_db_snapshot.db1_snapshot.id

  allocated_storage       = 50
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
  backup_retention_period = 2
  skip_final_snapshot     = true
  apply_immediately       = true
  iam_database_authentication_enabled = false
  storage_encrypted       = false

  tags = {
    Name              = "${var.mssql-db-target}-${var.environment_name}"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
  }
}

# create a read replica database from the EE instance
resource "aws_db_instance" "db_ee_replica" {
  allocated_storage   = 30
  instance_class      = "db.t3.xlarge"

  #name
  identifier          = "${var.mssql-db-target}-replica-${var.environment_name}"
  skip_final_snapshot = true

  replicate_source_db = aws_db_instance.mssql-ee.id

  tags = {
    Name              = "${var.mssql-db-target}-replica-${var.environment_name}"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
  }
}