
# HFS Postgres Master database
module "postgres_db_master" {
  source = "../modules/postgres"

  environment_name     = var.environment_name
  db_identifier        = "${var.db_identifier}-master"
  db_name              = data.aws_ssm_parameter.hfs_master_postgres_database.value
  db_engine            = var.db_engine
  db_engine_version    = var.db_engine_version
  db_instance_class    = "db.t3.medium" # check production 
  vpc_id               = "vpc-064521a7a4109ba31"
  db_allocated_storage = 50 # production = 240
  db_port              = var.db_port
  subnet_ids           = var.subnet_ids
  db_username          = data.aws_ssm_parameter.hfs_master_postgres_username.value
  db_password          = data.aws_ssm_parameter.hfs_master_postgres_password.value
  storage_encrypted    = var.storage_encrypted
  multi_az             = var.multi_az
  enabled_cloudwatch_logs_exports = ["postgresql"]
  maintenance_window   = var.maintenance_window
  backup_window        = "00:01-00:31"
  publicly_accessible  = var.publicly_accessible
  project_name         = var.project_name
  vpc_security_group_ids = ["sg-0ce270bb666a7ad64"]
}


# Replica 01 :: Accounts Information DB
resource "aws_db_instance" "postgres-replica-01" {
  identifier          = "${var.db_identifier}-replica-db-01-${var.environment_name}"
  replicate_source_db = "${var.db_identifier}-master-db-${var.environment_name}"
  depends_on          = [module.postgres_db_master.instance_id]
  instance_class      = "db.t3.medium"

  tags = {
    Name              = "${var.db_identifier}-replica-db-01-${var.environment_name}"
    Environment       = var.environment_name
    terraform-managed = true
    project_name      = var.project_name
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      storage_encrypted,
      allocated_storage,
      deletion_protection
    ]
  }
}

# Replica 02 :: Accounts Information DB
resource "aws_db_instance" "postgres-replica-02" {
  identifier          = "${var.db_identifier}-replica-db-02-${var.environment_name}"
  replicate_source_db = "${var.db_identifier}-master-db-${var.environment_name}"
  depends_on          = [module.postgres_db_master.instance_id]
  instance_class      = "db.t3.medium"

  tags = {
    Name              = "${var.db_identifier}-replica-db-02-${var.environment_name}"
    Environment       = var.environment_name
    terraform-managed = true
    project_name      = var.project_name
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      storage_encrypted,
      allocated_storage,
      deletion_protection
    ]
  }
}

# Replica 03 :: Charges DB
resource "aws_db_instance" "postgres-replica-03" {
  identifier          = "${var.db_identifier}-replica-db-03-${var.environment_name}"
  replicate_source_db = "${var.db_identifier}-master-db-${var.environment_name}"
  depends_on          = [module.postgres_db_master.instance_id]
  instance_class      = "db.t3.medium"

  tags = {
    Name              = "${var.db_identifier}-replica-db-03-${var.environment_name}"
    Environment       = var.environment_name
    terraform-managed = true
    project_name      = var.project_name
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      storage_encrypted,
      allocated_storage,
      deletion_protection
    ]
  }
}

# Replica 04 :: Accounts Information DB
resource "aws_db_instance" "postgres-replica-04" {
  skip_final_snapshot = true
  identifier          = "${var.db_identifier}-replica-db-04-${var.environment_name}"
  replicate_source_db = "${var.db_identifier}-master-db-${var.environment_name}"
  depends_on          = [module.postgres_db_master.instance_id]
  instance_class      = "db.t3.medium"

  tags = {
    Name              = "${var.db_identifier}-replica-db-04-${var.environment_name}"
    Environment       = var.environment_name
    terraform-managed = true
    project_name      = var.project_name
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      storage_encrypted,
      allocated_storage,
      deletion_protection
    ]
  }
}