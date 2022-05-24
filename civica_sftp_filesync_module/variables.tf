#=======================================================================
# Module
#=======================================================================

variable "environment" {
  description = "Provide Environment name"
  #default     = "dev" # dev/staging/prod
}

#=======================================================================
# IAM
#=======================================================================

locals {
  sid_1           = "s3-Bucket-Read"
  sid_2           = "s3-Bucket-Objects-Read"
  sid_3           = "s3-Bucket-Objects-Write"
  s3_content_type = "application/octet-stream"
}

variable "statemachine_lambda_name" {
  description = "The existing Statemachine lambda name"
  #default     = "housing-finance-interim-api-development-check-cash-files"


  #dev_name = "housing-finance-interim-api-development-check-cash-files"
  #staging_name  = "housing-finance-interim-api-staging-cash-file-trans"
  #prod          = "housing-finance-interim-api-production-cash-file"
}
variable "statemachine_lambda_role" {
  description = "The IAM role of the existing Lambda function - to access the S3 bucket and read the Civica cashfile"
  #default = "housing-finance-interim-api-development-eu-west-2-lambdaRole"

  #dev role     = housing-finance-interim-api-development-eu-west-2-lambdaRole
  #staging role = housing-finance-interim-api-lambdaExecutionRole
  #prod role    = housing-finance-interim-api-lambdaExecutionRole
}

#=======================================================================
# S3
#=======================================================================

variable "bucketName" {
  description = "provide bucket name"
  default     = "civica-sftp-cashfile-bucket"
}

variable "civica-sftp-fileSync-role" {
  description = "Civica SFTP File Sync role name"
  default     = "civica-sftp-fileSync-role"
}

variable "civica-sftp-s3-access-policy" {
  description = "S3 SFTP access policy"
  default     = "civica-sftp-s3-access-policy"
}

variable "bucket_folder_name" {
  description = "default bucket folder name"
  default     = "cashfiles"
}

#=======================================================================
# SFTP
#=======================================================================

# default identity provider
variable "identity_provider" {
  description = "default identity provider type"
  default     = "SERVICE_MANAGED"
}

# SFTP username
variable "sftp_user_name" {
  description = "Sftp user name"
  #default     = "civica.ifs"
}

# SFTP public key
variable "sftp_ssh_public_key" {
  description = "SSH public key"
  #default = data.aws_ssm_parameter.housing_finance_civica_sftp_username
  #default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMOv2jjcqsIy8/Dg8ltONiN91O+VsPJSNgW4Qi80LqdsEtJqbzWWZfnvN7NoqD97WC0ZPQuF7L354zfvFMi2lac77WJjBwIWIsNQ+XwcdKRdi4Je+hSionLtog3tauCg+Y3tcYuUBPY49c3efR4Oy8IydeBGApY+h90d7smVzjwpqfB2ItUWnzqLPkAFgbBQ2ctl6CSZE7SyLRvB2v4rjEfU48zRVwZPblDBNxOg8AS0RidDu3burapSRNA/h5qbdGnTOfqJ848NaA61k8IUZT4m8dKtYiC1RC1CSwSgAxiYIuXu4zwDXxTnK3KINtHoAiLZyDaMlgJ6PeQ/kEXtK94miUZ0AhKqGefaXcLFRAywtjlcPcpAo7nyKi8kr6Lk+zmJVVEBieWGHXiq9mIjxsW+xQrLs3Xjmpj5AbD+SI8cjYzGlcVvW1HHWrSwvFynDB/Aq9dCQvGrHbzXpM+Ap2pAa0w938LOSQHnHclfilZP1sTf2R7uDNlDz8MQz+YDc="
}
