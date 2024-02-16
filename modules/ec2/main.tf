# modules/ec2_instance/main.tf
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "security_group_ids" {}


resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = var.security_group_ids

  tags = {
    Name = "example-instance"
  }
}
