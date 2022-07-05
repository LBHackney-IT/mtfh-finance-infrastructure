variable "environment_name" {
  type = string
  default = "staging"
}

variable "mssql-db-source" {
  description = "The identifier name of the source MS SQL database"
  type = string
  default = "housing-finance"
}

variable "mssql-db-target" {
  description = "The identifier name of the target MS SQL database"
  type = string
  default = "housing-finance-sql-db"
}

variable "remote_lambda_role_arn" {
  description = "This is the ARN of the role of the Finance Lambda function which will access the S3 to write the Cash file"
  type    = string
  default = "arn:aws:iam::681487194339:role/civica-prod-file-sync-source-lambda-execution"
}

variable "statemachine_lambda_name" {
  description = "The name of the Cashfile Lambda"
  type    = string
  default = "housing-finance-interim-api-staging-check-cash-files"
}

variable "statemachine_lambda_role" {
  description = "The IAM role of the Cashfile Lambda"
  type    = string
  default = "housing-finance-interim-api-staging-eu-west-2-lambdaRole"
}