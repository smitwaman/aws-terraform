terraform {
  backend "s3" {
    bucket         = "dpt3-terraform-state"
    key            = "dpt3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dpt_table"
  }
}