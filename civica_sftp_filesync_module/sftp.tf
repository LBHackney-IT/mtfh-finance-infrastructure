#=======================================================================
# SFTP
#=======================================================================

#create the SFTP endpoint
resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = var.identity_provider
  logging_role           = aws_iam_role.fileSync_role.arn
}

#create user
data "aws_ssm_parameter" "housing_finance_civica_sftp_username" {
  name = "/housing-finance/development/civica-sftp-username"
}

data "aws_ssm_parameter" "housing_finance_civica_sftp_key" {
  name = "/housing-finance/development/civica-sftp-ssh-public-key"
}

resource "aws_transfer_user" "sftp_user" {
  depends_on     = [aws_s3_bucket.sftpbucket]
  server_id      = aws_transfer_server.sftp_server.id
  user_name      = data.aws_ssm_parameter.housing_finance_civica_sftp_username.value
  role           = aws_iam_role.fileSync_role.arn
  home_directory = "/${var.bucket_folder_name}"
}

# apply the public SSH-key
resource "aws_transfer_ssh_key" "ssh_key" {
  server_id = aws_transfer_server.sftp_server.id
  user_name = aws_transfer_user.sftp_user.user_name
  body      = data.aws_ssm_parameter.housing_finance_civica_sftp_key.value
}