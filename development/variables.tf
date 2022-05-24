variable "environment_name" {
  type = string
  default = "development"
}

variable "statemachine_lambda_name" {
  description = "The name of the Cashfile Lambda"
  type    = string
  default = "housing-finance-interim-api-development-check-cash-files"
}

variable "statemachine_lambda_role" {
  description = "The IAM role of the Cashfile Lambda"
  type    = string
  default = "housing-finance-interim-api-development-eu-west-2-lambdaRole"
}