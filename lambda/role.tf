resource "aws_iam_role" "webapp-lambda-role" {
  name        = "webapp-lambda-role"
  path        = "/"
  description = "Managed by Terraform"

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

data "aws_iam_policy" "sns" {
  arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_iam_role_policy_attachment" "webapp-lambda-sns" {
  role       = aws_iam_role.webapp-lambda-role.id
  policy_arn = data.aws_iam_policy.sns.arn
}

data "aws_iam_policy" "cloudwatch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "webapp-lambda-cloudatch" {
  role       = aws_iam_role.webapp-lambda-role.id
  policy_arn = data.aws_iam_policy.cloudwatch.arn
}

data "aws_iam_policy" "vpcaccess" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "webapp-lambda-acess" {
  role       = aws_iam_role.webapp-lambda-role.id
  policy_arn = data.aws_iam_policy.vpcaccess.arn
}

data "aws_iam_policy" "route53" {
  arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "webapp-lambda-r53" {
  role       = aws_iam_role.webapp-lambda-role.id
  policy_arn = data.aws_iam_policy.route53.arn
}

data "aws_iam_policy" "ec2" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "webapp-lambda-ec2" {
  role       = aws_iam_role.webapp-lambda-role.id
  policy_arn = data.aws_iam_policy.ec2.arn
}




