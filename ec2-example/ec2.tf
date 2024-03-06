resource "aws_instance" "ec2" {
    ami = data.aws_ami.example.id
    instance_type = "t2.micro"
    key_name = "dpt4"
    subnet_id = data.terraform_remote_state.vpc.outputs.pub_subnet
    security_groups = [aws_security_group.allow_tls.id]
    iam_instance_profile = aws_iam_instance_profile.test_profile.name
    
}