variable "operation_name" {
  type    = string
  default = "hfs-nightly-jobs-charges-ingest"
}


# Environment-specific variables
###################################################################

variable "environment" {
  type    = string
  default = "development"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0d15f152935c8716f"
}

variable "aws_subnet_ids" {
  type    = list(any)
  default = ["subnet-05ce390ba88c42bfd", "subnet-0140d06fb84fdb547"]
}

variable "charges_cron_expression" {
  type    = string
  default = "cron(30 0 * * ? *)"
}

variable "charges_schedule_enabled" {
  type    = bool
  default = false
}