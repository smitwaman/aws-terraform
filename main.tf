module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}



module "terraform_backend" {
  source      = "./modules/s3_backend"
  bucket_name = "your_bucket_name"
  region      = "us-east-1"
}


module "subnets" {
  source                = "./modules/subnet"
  vpc_id                = module.vpc.vpc_id
  public_subnet_cidr_a  = "10.0.1.0/24"
  public_subnet_cidr_b  = "10.0.2.0/24"
  private_subnet_cidr_a = "10.0.3.0/24"
  private_subnet_cidr_b = "10.0.4.0/24"
  availability_zone_a   = "eu-north-1a"
  availability_zone_b   = "eu-north-1b"
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


module "ec2_instance" {
  source = "./modules/ec2_instance"

  ami_id             = "ami-12345678"
  instance_type      = "t2.micro"
  key_name           = "your_key_pair_name"
  security_group_ids = ["sg-12345678"]
}

# Provisioner to execute shell script
provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/setup.sh",          # Make script executable
    "sudo /tmp/setup.sh"               # Execute the script
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"            # Specify the SSH user for the instance
    private_key = file("path/to/your/private_key.pem")  # Specify the path to your private key
    host        = self.public_ip       # Use public IP to connect
  }
}
