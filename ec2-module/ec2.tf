data "aws_ami" "dptami" {
  most_recent      = true
  owners           = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20210813.1-x86_64-gp2*"]
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "dpt-web-data"
    key    = "dpt/vpc/dpt-vpc"
    region = "us-east-1"
    }
  }

resource "aws_eip" "dptip" {
  instance = aws_instance.dptinstance.id
  vpc      = true
}

resource "aws_instance" "dptinstance" {
    ami = data.aws_ami.dptami.id
    associate_public_ip_address = var.associate_public_ip_address
    key_name = var.key_name
    instance_type = var.instance_type
    subnet_id = data.terraform_remote_state.vpc.outputs.pub_subnet

}

