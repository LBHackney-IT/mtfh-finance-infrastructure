#=======================================================================
# Locals
#=======================================================================

locals {
  sid_1           = "s3BucketRead"
  sid_2           = "s3BucketObjectsRead"
  sid_3           = "s3BucketObjectsWrite"
  s3_content_type = "application/octet-stream"
}

#=======================================================================
# Module
#=======================================================================

variable "environment" {
  description = "Provide Environment name"
  type = string
}

variable "statemachine_lambda_name" {
  description = "The existing Statemachine lambda name"
  type = string
}

variable "statemachine_lambda_role" {
  description = "The IAM role of the existing Lambda function - to access the S3 bucket and read the Civica cashfile"
  type = string
}

variable "remote_lambda_role_arn" {
  description = "This is the ARN of the role of the remote Lambda function which will access the S3"
  type = string
}

#=======================================================================
# IAM
#=======================================================================

variable "civica_sftp_fileSync_role" {
  description = "Civica SFTP File Sync role name"
  default     = "Civica_sftp_fileSync_role"
  type        = string
}

variable "civica_sftp_s3_access_policy" {
  description = "S3 SFTP access policy"
  default     = "Civica_sftp_s3_access_policy"
  type        = string
}

#=======================================================================
# S3
#=======================================================================

variable "bucketName" {
  description = "provide bucket name"
  default     = "civica-sftp-cashfile-bucket"
  type        = string
}

variable "bucket_folder_name" {
  description = "default bucket folder name"
  default     = "cashfiles"
  type        = string
}

#=======================================================================
# SFTP
#=======================================================================

# default identity provider
variable "identity_provider" {
  description = "default identity provider type"
  default     = "SERVICE_MANAGED"
}

