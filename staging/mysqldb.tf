data "aws_ssm_parameter" "housing_finance_mysql_database" {
  name = "/housing-finance/staging/mysql-database"
}
data "aws_ssm_parameter" "housing_finance_mysql_username" {
  name = "/housing-finance/staging/mysql-username"
}
data "aws_ssm_parameter" "housing_finance_mysql_password" {
  name = "/housing-finance/staging/mysql-password"
}

# MySQL Database Setup
resource "aws_db_subnet_group" "db_subnets" {
  name       = "housing-finance-db-subnet-${var.environment_name}"
  subnet_ids = ["subnet-0743d86e9b362fa38","subnet-0ea0020a44b98a2ca"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "mtfh_finance_security_group" {
  name        = "mtfh-finance-allowdb-traffic-${var.environment_name}"
  description = "Allow traffic for the various database types"
  vpc_id      = "vpc-064521a7a4109ba31"

  ingress {
    description      = "Allow MySql"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow MsSql"
    from_port        = 1433
    to_port          = 1433
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow Redis"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_db_instance" "housing-mysql-db" {
  identifier                  = "housing-finance-db-${var.environment_name}"
  engine                      = "mysql"
  engine_version              = "8.0.20"
  instance_class              = "db.t2.micro" //this should be a more production appropriate instance in production
  allocated_storage           = 10
  storage_type                = "gp2" //ssd
  port                        = 3306
  backup_window               = "00:01-00:31"
  username                    = data.aws_ssm_parameter.housing_finance_mysql_username.value
  password                    = data.aws_ssm_parameter.housing_finance_mysql_password.value
  vpc_security_group_ids      = aws_security_group.mtfh_finance_security_group.id
  db_subnet_group_name        = aws_db_subnet_group.db_subnets.name
  name                        = data.aws_ssm_parameter.housing_finance_mysql_database.value
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
