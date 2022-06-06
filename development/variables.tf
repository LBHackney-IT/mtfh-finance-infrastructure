variable "environment_name" {
  type = string
  default = "development"
}

variable "remote_lambda_role_arn" {
  description = "This is the ARN of the role of the Finance Lambda function which will access the S3 to write the Cash file"
  type    = string
  default = "arn:aws:iam::681487194339:role/civica-prod-file-sync-source-lambda-execution"
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