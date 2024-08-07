#=======================================================================
# S3
#=======================================================================

resource "aws_s3_bucket" "sftpbucket" {
  bucket = "${var.bucketName}-${var.environment}"
}

# Create the /cashfiles folder in the S3 bucket
#resource "aws_s3_object" "s3_folder" {
#  depends_on   = [aws_s3_bucket.sftpbucket]
#  bucket       = aws_s3_bucket.sftpbucket.id
#  key          = "${var.bucket_folder_name}/"
#  content_type = local.s3_content_type
#}

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

#=======================================================================
# Add a lambda-trigger to process the S3 PUT event
#=======================================================================
# 1) the lambda 
data "aws_lambda_function" "statemachine_cashfile_lambda" {
  function_name = var.statemachine_lambda_name
}

# 2) Add a bucket lambda trigger for the PUT event
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.sftpbucket.id
  lambda_function {
    lambda_function_arn = data.aws_lambda_function.statemachine_cashfile_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.bucket_folder_name}/"
    filter_suffix       = ".dat"
  }
}

# 3) Apply the permission
resource "aws_lambda_permission" "lambda_trigger_perms" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.statemachine_cashfile_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.sftpbucket.id}"
}