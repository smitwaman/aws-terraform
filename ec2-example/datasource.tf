data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket         = "dpt4-terraform-state"
    key            = "dpt4/vpc/terraform.tfstate"
    region         = "us-east-1"
  }
}

data "aws_ami" "example" {
  most_recent      = true
  owners           = ["135159588584"]

  filter {
    name   = "name"
    values = ["dt-ami-01*"]
  }
}