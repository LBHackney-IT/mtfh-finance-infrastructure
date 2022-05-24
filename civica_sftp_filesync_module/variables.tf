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
  sid_1           = "s3BucketRead"
  sid_2           = "s3BucketObjectsRead"
  sid_3           = "s3BucketObjectsWrite"
  s3_content_type = "application/octet-stream"
}

variable "statemachine_lambda_name" {
  description = "The existing Statemachine lambda name"
}

variable "statemachine_lambda_role" {
  description = "The IAM role of the existing Lambda function - to access the S3 bucket and read the Civica cashfile"
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
}

# SFTP public key
variable "sftp_ssh_public_key" {
  description = "SSH public key"
}
