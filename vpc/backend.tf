terraform {
  backend "s3" {
    bucket         = "dpt4-terraform-state"
    key            = "dpt4/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dpt4_table"
  }
}