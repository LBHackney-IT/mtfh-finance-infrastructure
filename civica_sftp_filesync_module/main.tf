#=======================================================================
# IAM configuration
#=======================================================================
resource "aws_iam_role" "fileSync_role" {
  name               = var.civica_sftp_fileSync_role
  description        = "Civica cashfile sync IAM Role"
  assume_role_policy = file("${path.module}/assumerolepolicy.json")
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = var.civica_sftp_s3_access_policy
  description = "Civica cashfile sync IAM policy"
  policy      = data.template_file.iam_policy_template.rendered
}

# Assign variables to the policy template
data "template_file" "iam_policy_template" {
  template = file("${path.module}/Civica-FileSync-S3-Bucket-Policy.tpl")
  vars = {
    "sid-1"           = local.sid_1
    "sid-2"           = local.sid_2
    "sid-3"           = local.sid_3
    "s3-resource-arn" = aws_s3_bucket.sftpbucket.arn
  }
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
