{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "TransferPolicy",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "transfer.amazonaws.com"
      }
    },
    {
      "Sid": "FinanceRoleTrustPolicy",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${remote-trusted-role-arn}"
      }
    }      
  ]
}