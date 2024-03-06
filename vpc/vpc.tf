resource "aws_vpc" "dpt2_vpc" {
cidr_block = var.vpcid

tags = {
    Name = "dpt2_vpc"
  }

}

resource "aws_internet_gateway" "dpt2_gw" {
    vpc_id = aws_vpc.dpt2_vpc.id

}

resource "aws_eip" "ip" {
}

resource "aws_nat_gateway" "dpt2_nat" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.dpt2_pub_sub1.id

}