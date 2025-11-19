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
  default = "vpc-006989d0b2bb070d9"
}

variable "aws_subnet_ids" {
  type    = list(any)
  default = ["subnet-05e595c59b7d6c8df","subnet-0e6bc9b4ac24493cc"]
}

variable "charges_cron_expression" {
  type    = string
  default = "cron(46 15 * * ? *)"
}