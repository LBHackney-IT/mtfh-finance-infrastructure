resource "aws_s3_bucket" "mtfh_print" {
  bucket = "mtfh-finance-printroom-${var.environment_name}"

  tags = {
    Name        = "mtfh-finance-printroom-${var.environment_name}"
    Environment = "${var.environment_name}"
  }
}

resource "aws_s3_bucket_acl" "print_acl" {
  bucket = aws_s3_bucket.mtfh_print.id
  acl    = "private"
}

# TODO: - Permissions to be clarified on who has access, and how would they access to create bucket policy
#       - Object lifecycle; how long do we keep objects in the bucket for and what happens when they expire
#       - Versioning; would these objects change?  If so do we need to keep the older versions?
#       - Enryption; what level of encryption do we need?
