###################################
### IAM Role
###################################
 
resource "aws_iam_role" "dpt_role" {
  name        = "dpt_role"
  path        = "/"
  description = "IAM Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

data "aws_iam_policy" "cloudWatch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

data "aws_iam_policy" "SecretsManager" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

data "aws_iam_policy" "vpc" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy" "sns" {
  arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}


resource "aws_iam_policy" "s3_policy" {
name = "dpt-s3-policy"
policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetObjectAcl",
                "s3:DeleteObjectVersion",
                "s3:DeleteObject",
                "s3:ListBucketVersions",
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::dpt-web-data/*",
                "arn:aws:s3:::dpt-web-data"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:HeadBucket",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:CreateBucket",
                "s3:GetBucketVersioning",
                "s3:PutBucketVersioning"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sns" {
  role       = aws_iam_role.dpt_role.id
  policy_arn = data.aws_iam_policy.sns.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.dpt_role.id
  policy_arn = data.aws_iam_policy.cloudWatch.arn
}

resource "aws_iam_role_policy_attachment" "vpc" {
  role       = aws_iam_role.dpt_role.id
  policy_arn = data.aws_iam_policy.vpc.arn
}

resource "aws_iam_role_policy_attachment" "SecretsManager" {
  role       = aws_iam_role.dpt_role.id
  policy_arn = data.aws_iam_policy.SecretsManager.arn
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.dpt_role.id
  policy_arn = aws_iam_policy.s3_policy.arn
}
