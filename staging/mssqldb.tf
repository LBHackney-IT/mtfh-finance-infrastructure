# MS SQL Server DB Setup (no common resource)
resource "aws_db_subnet_group" "mssql_db_subnets" {
  name       = "housing-finance-mssql-db-subnet-${var.environment_name}"
  subnet_ids = ["subnet-0ea0020a44b98a2ca","subnet-0743d86e9b362fa38"]
  lifecycle {
    create_before_destroy = true
  }
}

# use Snapshot1 to create a database with EE instance
resource "aws_db_instance" "hfs-mssql-web" {
  allocated_storage       = 100
  engine                  = "sqlserver-web"
  engine_version          = "15.00.4073.23.v1"
  instance_class          = "db.t3.xlarge"
  license_model           = "license-included"
  identifier              = "${var.mssql-db-target}-${var.environment_name}"
  username                = data.aws_ssm_parameter.housing_finance_mssql_username.value
  password                = data.aws_ssm_parameter.housing_finance_mssql_password.value
  vpc_security_group_ids  = [aws_security_group.mtfh_finance_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.mssql_db_subnets.name
  publicly_accessible     = false
  backup_retention_period = 7
  skip_final_snapshot     = true
  apply_immediately       = true
  iam_database_authentication_enabled = false
  storage_encrypted       = true

  tags = {
    Name              = "${var.mssql-db-target}-${var.environment_name}"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
  }

  lifecycle {
    prevent_destroy   = false
    ignore_changes    = [
      storage_encrypted
    ]
  }  
}
