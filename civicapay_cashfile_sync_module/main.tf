#=======================================================================
# IAM Policy for S3 - To allow remote lambda access to S3
#=======================================================================

# Assign variables to the policy template
data "template_file" "iam_remote_role_policy_template" {
  template = file("${path.module}/Policy-template-S3.tpl")
  vars = {
    "remote-trusted-role-arn" = var.remote_lambda_role_arn
    "s3-bucket-arn" = aws_s3_bucket.sftpbucket.arn
  }
}

# Attach the remote lambda access policy to the S3
resource "aws_s3_bucket_policy" "remote_lambda_access" {
  bucket = aws_s3_bucket.sftpbucket.bucket
  policy = data.template_file.iam_remote_role_policy_template.rendered
}

#=======================================================================
# IAM Policy for Lambda - To allow local lambda access to S3
#=======================================================================

# Assign variables to the policy template
data "template_file" "iam_policy_template" {
  template = file("${path.module}/Policy-template-Lambda.tpl")
  vars = {
    "sid-1"           = local.sid_1
    "sid-2"           = local.sid_2
    "sid-3"           = local.sid_3
    "s3-resource-arn" = aws_s3_bucket.sftpbucket.arn
  }
}

// Policy resource of the S3 Bucket
resource "aws_iam_policy" "local_lambda_s3_access_policy" {
  name        = var.civica_sftp_s3_access_policy
  description = "Civica cashfile sync IAM policy"
  policy      = data.template_file.iam_policy_template.rendered
}

# Attach the S3 access policy to the Lambda role
resource "aws_iam_policy_attachment" "civica_sftp_attach" {
  name = "civica_sftp_attach"
  roles = [
    var.statemachine_lambda_role
  ]
  policy_arn = aws_iam_policy.local_lambda_s3_access_policy.arn
}
