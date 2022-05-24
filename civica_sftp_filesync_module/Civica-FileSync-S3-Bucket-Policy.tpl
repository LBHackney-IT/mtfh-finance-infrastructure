{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "${sid-1}",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucketMultipartUploads",
                "s3:ListBucketVersions",
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": "${s3-resource-arn}" 
        },
        {
            "Sid": "${sid-2}",
            "Effect": "Allow",
            "Action": [
                "s3:ListStorageLensConfigurations",
                "s3:ListAccessPointsForObjectLambda",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:ListJobs",
                "s3:ListMultiRegionAccessPoints"
            ],
            "Resource": "*"
        },
        {
            "Sid": "${sid-3}",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObjectVersion",
                "s3:DeleteObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "${s3-resource-arn}/*"
        }
    ]
}