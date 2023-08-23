variable "operation_name" {
  type    = string
  default = "hfs-nightly-jobs-charges-ingest"
}


# Environment-specific variables
###################################################################

variable "environment" {
  type    = string
  default = "staging"
}

variable "vpc_id" {
  type    = string
  default = "vpc-064521a7a4109ba31"
}

variable "aws_subnet_ids" {
  type    = list(any)
  default = ["subnet-0743d86e9b362fa38","subnet-0ea0020a44b98a2ca"]
}

variable "charges_cron_expression" {
  type    = string
  default = "cron(30 0 * * ? *)"
}