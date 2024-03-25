module "db_security_group" {
  source           = "github.com/LBHackney-IT/aws-hackney-common-terraform.git//modules/security_groups/database/internal_only_traffic"
  vpc_id           = var.vpc_id
  db_name          = var.db_name
  db_port          = var.db_port
  environment_name = var.environment_name
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.db_name}-db-subnet-${var.environment_name}"
  subnet_ids = var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "lbh-db" {
  identifier                  = "${var.db_identifier}-db-${var.environment_name}"
  engine                      = "postgres"
  engine_version              = var.db_engine_version # Use an appropriate db version for production instances
  instance_class              = var.db_instance_class # Use an appropriate instance class for production instances
  allocated_storage           = var.db_allocated_storage
  storage_type                = "gp2" //ssd
  port                        = var.db_port
  maintenance_window          = var.maintenance_window
  backup_window               = var.backup_window
  username                    = var.db_username
  password                    = var.db_password
  vpc_security_group_ids      = var.vpc_security_group_ids
  db_subnet_group_name        = aws_db_subnet_group.db_subnets.name
  db_name                     = var.db_name
  monitoring_interval         = 0 //this is for enhanced Monitoring there will allready be some basic monitering avalable
  backup_retention_period     = 30
  storage_encrypted           = true
  deletion_protection         = false
  multi_az                    = var.multi_az
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  enabled_cloudwatch_logs_exports = []

  apply_immediately   = false
  skip_final_snapshot = true
  publicly_accessible = var.publicly_accessible

  tags = {
    Name              = "${var.db_name}-db-${var.environment_name}"
    Environment       = var.environment_name
    terraform-managed = true
    project_name      = var.project_name
    BackupPolicy      = var.backup_policy
  }

  tags_all = {
    BackupPolicy = var.backup_policy
  }
}