#configure provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "dpt4-terraform-state"
    key            = "dpt4/ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dpt4_table"
  }
}

module "webserver" {
  source              = "./modules/webserver"
  instance_type = var.instance_type
  instance_profile = var.instance_profile
  dns_name = var.dns_name
  keypair = var.keypair
  asg_min_cap = var.asg_min_cap
  asg_max_cap = var.asg_max_cap
  asg_desired_cap = var.asg_desired_cap   
}

