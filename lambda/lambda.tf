#configure provider
provider "aws" {
  region = "us-east-1"
}

data "archive_file" "webapp" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/index.zip"
}

#Lambda Function
resource "aws_lambda_function" "webapp_lambda" {
  filename         = "${data.archive_file.webapp.output_path}"
  function_name = "webapp-lambda"
  role          = aws_iam_role.webapp-lambda-role.arn
  handler       = "index.lambda_handler"
  description      = "A function to provide register Auto Scaled EC2 Instance A Record in Route53"

  source_code_hash = "${data.archive_file.webapp.output_base64sha256}"
  timeout = 60

  runtime = "python3.8"
 
   }