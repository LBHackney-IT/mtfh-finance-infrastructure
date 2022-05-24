#=======================================================================
# S3
#=======================================================================

resource "aws_s3_bucket" "sftpbucket" {
  bucket = "${var.bucketName}-${var.environment}"
}

# Create the /cashfiles folder in the S3 bucket
resource "aws_s3_bucket_object" "s3_folder" {
  depends_on   = [aws_s3_bucket.sftpbucket]
  bucket       = aws_s3_bucket.sftpbucket
  key          = "${var.bucket_folder_name}/"
  content_type = local.s3_content_type
}

# Add a lifecyle config to remove files older than 30 days
resource "aws_s3_bucket_lifecycle_configuration" "lc" {
  bucket = aws_s3_bucket.sftpbucket.id
  rule {
    status = "Enabled"
    id     = "30_day_expiry"
    expiration {
      days = 30
    }
  }
}

# To add a lambda-trigger to respond the S3 PUT event:
# 1) the lambda ARN
data "aws_lambda_function" "existingCashfileLambda" {
  function_name = var.statemachine_lambda_name
}

# 2) Add a bucket lambda trigger for the PUT event
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.sftpbucket.id
  lambda_function {
    lambda_function_arn = data.aws_lambda_function.existingCashfileLambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.bucket_folder_name}/"
    filter_suffix       = ".dat"
  }
}