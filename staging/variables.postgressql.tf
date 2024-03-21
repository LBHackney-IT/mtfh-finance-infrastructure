variable "db_identifier" {
  type    = string
  default = "housing-finance-postgres"
}
variable "db_port" {
  type    = string
  default = "5432"
}
variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-0ea0020a44b98a2ca", "subnet-0743d86e9b362fa38"]
}
variable "db_engine" {
  type    = string
  default = "postgres"
}
variable "db_engine_version" {
  type    = string
  default = "14.10"
}
variable "maintenance_window" {
  type    = string 
  default = "tue:01:00-tue:03:00"
}
variable "storage_encrypted" {
  type    = bool
  default = true
}
variable "multi_az" {
  type    = bool
  default = true
}
variable "publicly_accessible" {
  type    = bool
  default = false
}
variable "project_name" {
  type    = string
  default = "Housing-Finance PostgresSQL master and read-replica cluster"
}