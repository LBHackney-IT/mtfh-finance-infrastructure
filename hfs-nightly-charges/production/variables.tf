variable "operation_name" {
  type    = string
  default = "hfs-nightly-jobs-charges-ingest"
}


# Environment-specific variables
###################################################################

variable "environment" {
  type    = string
  default = "production"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0ce853ddb64e8fb3c"
}

variable "aws_subnet_ids" {
  type    = list(any)
  default = ["subnet-0beb266003a56ca82","subnet-06a697d86a9b6ed01"]
}

variable "charges_cron_expression" {
  type    = string
  default = "cron(30 0 * * ? *)"
}