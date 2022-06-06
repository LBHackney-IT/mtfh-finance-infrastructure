#=======================================================================
# IAM Role configuration
#=======================================================================

# Assign variables to the policy template
data "template_file" "iam_remote_role_policy_template" {
  template = file("${path.module}/Policy-termplate-IAM-Role.tpl")
  vars = {
    "remote-trusted-role-arn" = var.remote_lambda_role_arn
  }
}

resource "aws_iam_role" "fileSync_role" {
  name               = var.civica_sftp_fileSync_role
  description        = "Civica cashfile sync IAM Role"
  assume_role_policy = data.template_file.iam_remote_role_policy_template.rendered
}

#=======================================================================
# S3 Permissions configuration
#=======================================================================

# Assign variables to the policy template
data "template_file" "iam_policy_template" {
  template = file("${path.module}/Policy-termplate-Civica-FileSync-S3-Bucket.tpl")
  vars = {
    "sid-1"           = local.sid_1
    "sid-2"           = local.sid_2
    "sid-3"           = local.sid_3
    "s3-resource-arn" = aws_s3_bucket.sftpbucket.arn
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = var.civica_sftp_s3_access_policy
  description = "Civica cashfile sync IAM policy"
  policy      = data.template_file.iam_policy_template.rendered
}

# Attach the permission to 2 roles = the S3 and the Statemachine Lambda
resource "aws_iam_policy_attachment" "civica_sftp_attach" {
  name = "civica_sftp_attach"
  roles = [
    "${aws_iam_role.fileSync_role.name}",
    var.statemachine_lambda_role
  ]
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "civica_sftp_profile" {
  name = "civica_sftp_profile"
  role = aws_iam_role.fileSync_role.name
}
