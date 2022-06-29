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
        }
    ]
}