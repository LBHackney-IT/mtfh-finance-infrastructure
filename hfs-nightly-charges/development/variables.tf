variable "environment" {
  type    = string
  default = "development"
}

variable "operation_name" {
  type    = string
  default = "hfs-nightly-jobs-charges-ingest"
}

variable "housing_finance_prefix" {
  type    = string
  default = "/housing-finance"
}