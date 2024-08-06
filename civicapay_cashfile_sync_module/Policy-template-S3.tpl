{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CrossAccountShare",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${remote-trusted-role-arn}"
            },
            "Action": "s3:*",
            "Resource": [
                "${s3-bucket-arn}",
                "${s3-bucket-arn}/*"
            ]
        },
        {
            "Sid": "AllowSSLRequestsOnly",
            "Effect": "Deny",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::civica-sftp-cashfile-bucket-production",
                "arn:aws:s3:::civica-sftp-cashfile-bucket-production/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}