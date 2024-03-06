resource "aws_iam_role" "test_role" {
  name = "dpt4_testing_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "dpt4_policy_testing"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucketMultipartUploads",
                "s3:ListBucketVersions",
                "s3:ListBucket",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": "arn:aws:s3:::dpt3-terraform-state"
        },
        {
            "Sid": "VisualEditor1",
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
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.policy.arn
}
resource "aws_iam_instance_profile" "test_profile" {
  name = "dpt4_testing_role"
  role = aws_iam_role.test_role.name
}