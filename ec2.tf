resource "aws_instance" "public_instance" {
  ami                    = "ami-05fb0b8c1424f266b"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true
  ssh_keys = [var.ssh_key_fingerprint]  # SSH keys to be injected into the droplet

  # Run the shell script after the droplet is created
  provisioner "local-exec" {
    command = "./install.sh"
  }
  tags = {
    Name = "public_instance"
}
}

output "public_ip" {
  value = aws_instance.public_instance.public_ip
}
