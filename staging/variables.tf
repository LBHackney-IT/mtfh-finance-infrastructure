variable "environment_name" {
  type = string
  default = "staging"
}

variable "statemachine_lambda_name" {
  description = "The name of the Cashfile Lambda"
  type    = string
  default = "housing-finance-interim-api-staging-cash-file-trans"
}

variable "statemachine_lambda_role" {
  description = "The IAM role of the Cashfile Lambda"
  type    = string
  default = "housing-finance-interim-api-lambdaExecutionRole"
}