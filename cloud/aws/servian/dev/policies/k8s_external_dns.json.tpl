{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets",
                "route53:GetChange"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "route53:ListHostedZones",
                "route53:ListHostedZonesByName",
                "route53:GetChange"
            ],
            "Resource": "*"
        }
    ]
}
