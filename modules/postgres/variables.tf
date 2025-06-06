variable "vpc_id" {
  type = string
}
variable "db_identifier" {
  type = string
}
variable "db_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "db_port" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "db_engine" {
  type = string
}
variable "db_engine_version" {
  type = string
}
variable "db_parameter_group_name" {
  description = "Allows attach a specific db parameter group by its name."
  type        = string
  default     = null
}
variable "db_instance_class" {
  type = string
}
variable "db_allocated_storage" {
  type = string
}
variable "maintenance_window" {
  type = string //e.g. "tue:10:00-tue:10:30"
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "storage_encrypted" {
  type = string
}
variable "multi_az" {
  type = string
}
variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = []
}
variable "publicly_accessible" {
  type = string
}
variable "project_name" {
  type = string
}
variable "backup_policy" {
  type    = string
  default = null
}
variable "vpc_security_group_ids" {
  type = list(string)
}

variable "backup_window" {
  type = string
}

variable "additional_tags" {
  description = "Additional tags to be added to the RDS instance"
  type        = map(any)
  default     = {}
}
