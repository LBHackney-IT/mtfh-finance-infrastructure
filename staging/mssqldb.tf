# MS SQL Server DB Setup (no common resource)
resource "aws_db_subnet_group" "mssql_db_subnets" {
  name       = "housing-finance-mssql-db-subnet-${var.environment_name}"
  subnet_ids = ["subnet-0ea0020a44b98a2ca","subnet-0743d86e9b362fa38"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "mssql" {
  allocated_storage    = 30
  engine               = "sqlserver-ee"
  engine_version       = "15.00.4198.2.v1"
  instance_class       = "db.t3.xlarge"
  license_model        = "license-included"
  identifier           = "housing-finance-sql-db-${var.environment_name}"
  username             = data.aws_ssm_parameter.housing_finance_mssql_username.value
  password             = data.aws_ssm_parameter.housing_finance_mssql_password.value
  vpc_security_group_ids      = [aws_security_group.mtfh_finance_security_group.id]
  db_subnet_group_name = aws_db_subnet_group.mssql_db_subnets.name
  multi_az              = false
  publicly_accessible    = false
  backup_retention_period = 2
  skip_final_snapshot = true
  apply_immediately = true

  tags = {
    Name              = "housing-finance-db-${var.environment_name}"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
  }
}

resource "aws_db_instance" "mssql-replica" {
  allocated_storage       = 30
  #engine                  = "sqlserver-ee"
  #engine_version          = "15.00.4198.2.v1"
  instance_class          = "db.t3.xlarge"
  license_model           = "license-included"
  identifier              = "housing-finance-sql-db-${var.environment_name}-replica"
  replicate_source_db     = aws_db_instance.mssql.id
  vpc_security_group_ids  = [aws_security_group.mtfh_finance_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.mssql_db_subnets.name
  multi_az                = false
  publicly_accessible     = false
  storage_encrypted       = true
  backup_retention_period = 2

  apply_immediately = "true"

  tags = {
    Name              = "housing-finance-db-${var.environment_name}"
    Environment       = "${var.environment_name}"
    terraform-managed = true
    project_name      = "MTFH Finance"
  }
}