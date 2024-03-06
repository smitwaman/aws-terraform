provider "aws" {
  region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket         = "dpt-k8s-config-data"
    key            = "dft/ec2/terraform.tfstate"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend   = "s3"

  config = {
    bucket         = "dpt-k8s-config-data"
    key            = "dft/vpc/terraform.tfstate"
    region         = "us-east-1"
  }
}

data "aws_ami" "dpt_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220419.0-x86_64-gp2"]
  }
}

resource "aws_security_group" "dpt_sg" {
  name        = "${var.application}-dpt-security-group"
  description = "Allow dpt traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "dpt_lc" {
  name_prefix   = "${var.application}-lc-"
  image_id             = data.aws_ami.dpt_ami.id
  key_name     = var.keypair
  security_groups      = [aws_security_group.dpt_sg.id]
  enable_monitoring    = var.enable_monitor
  ebs_optimized        = var.enable_ebs_optimization
  instance_type        = var.instance_type

  root_block_device {
    volume_type           = var.root_ebs_type
    volume_size           = var.root_ebs_size
    delete_on_termination = var.root_ebs_del_on_term
    
  }

  associate_public_ip_address = var.associate_public_ip_address
  
}

resource "aws_autoscaling_group" "dpt_asg" {
  name                      = "${var.application}-dpt-asg"
  max_size                  = var.asg_max_cap
  min_size                  = var.asg_min_cap
  desired_capacity          = var.asg_desired_cap
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  force_delete              = var.asg_force_delete
  termination_policies      = var.asg_termination_policies
  suspended_processes       = var.asg_suspended_processes
  launch_configuration      = aws_launch_configuration.dpt_lc.name
  vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.priv_subnet]
  default_cooldown          = var.asg_default_cooldown
  enabled_metrics           = var.asg_enabled_metrics
  metrics_granularity       = var.asg_metrics_granularity
  protect_from_scale_in     = var.asg_protect_from_scale_in
  target_group_arns         = ["${aws_lb_target_group.webtg1.arn}"]
  
  tag {
    key                 = "application"
    value               = "${var.application}-dpt"
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "webtg1" {
  name     = "${var.application}-tg1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

health_check {
                path = "/index.html"
                port = "80"
                protocol = "HTTP"
                healthy_threshold = 2
                unhealthy_threshold = 2
                interval = 5
                timeout = 4
                matcher = "200-308"
        }
}

resource "aws_security_group" "elb" {
  name        = "${var.application}-alb-sg"
  description = "ALB SG"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  # HTTP access from anywhere
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb" "dpt" {
  name               = "${var.application}-dpt"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.elb.id}"]
  subnets            =   [data.terraform_remote_state.vpc.outputs.pub_subnet1,data.terraform_remote_state.vpc.outputs.pub_subnet2]

 tags = {
      application         = "${var.application}-dpt"
  }
}

resource "aws_lb_listener" "web_tg1" {
  load_balancer_arn = "${aws_lb.dpt.arn}"
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.webtg1.arn}"
  }
}




