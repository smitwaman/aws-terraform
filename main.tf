module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}





module "subnets" {
  source                = "./modules/subnet"
  vpc_id                = module.vpc.vpc_id
  public_subnet_cidr_a  = "10.0.1.0/24"
  public_subnet_cidr_b  = "10.0.2.0/24"
  private_subnet_cidr_a = "10.0.3.0/24"
  private_subnet_cidr_b = "10.0.4.0/24"
  availability_zone_a   = "us-east-2a"
  availability_zone_b   = "us-east-2b"
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "nat_gateway" {
  source           = "./modules/nat_gateway"
  public_subnet_id = module.subnets.public_subnet_id_a
}

module "route_table" {
  source              = "./modules/route_table"
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.igw.igw_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
  public_subnet_id_a  = module.subnets.public_subnet_id_a
  public_subnet_id_b  = module.subnets.public_subnet_id_b
  private_subnet_id_a = module.subnets.private_subnet_id_a
  private_subnet_id_b = module.subnets.private_subnet_id_b
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

resource "aws_instance" "EC2" {
  ami             = "ami-06b74af9fe7907906"  # Specify your desired AMI
  instance_type   = "t2.micro"     # Specify your desired instance type
  subnet_id       =  aws_subnet.public_subnet_b.id
  security_groups = [aws_security_group.allow_web.name]

  # Example: Provisioning script to install software
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              EOF

  tags = {
    Name = "Instance"
  }
}
