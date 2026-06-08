data "aws_vpc" "cmtr-031bfa7b-vpc" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-031bfa7b-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cmtr-031bfa7b-vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_security_group" "ec2_sg" {
  filter {
    name   = "group-name"
    values = ["cmtr-031bfa7b-ec2_sg"]
  }

  vpc_id = data.aws_vpc.cmtr-031bfa7b-vpc.id
}

data "aws_security_group" "http_sg" {
  filter {
    name   = "group-name"
    values = ["cmtr-031bfa7b-http_sg"]
  }

  vpc_id = data.aws_vpc.cmtr-031bfa7b-vpc.id
}

data "aws_security_group" "sglb" {
  filter {
    name   = "group-name"
    values = ["cmtr-031bfa7b-sglb"]
  }

  vpc_id = data.aws_vpc.cmtr-031bfa7b-vpc.id
}

data "aws_iam_instance_profile" "instance_profile" {
  name = "cmtr-031bfa7b-instance_profile"
}

data "aws_key_pair" "keypair" {
  key_name = "cmtr-031bfa7b-keypair"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd jq
    systemctl enable httpd
    systemctl start httpd

    TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
    PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

    cat > /var/www/html/index.html <<HTML
    <html>
      <body>
        <h1>Instance ID: $INSTANCE_ID</h1>
        <h1>Private IP: $PRIVATE_IP</h1>
      </body>
    </html>
    HTML
  EOF
}

resource "aws_launch_template" "cmtr-031bfa7b-template" {
  name          = "cmtr-031bfa7b-template"
  instance_type = "t3.micro"
  image_id      = data.aws_ami.amazon_linux.id
  key_name      = data.aws_key_pair.keypair.key_name

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups = [
      data.aws_security_group.ec2_sg.id,
      data.aws_security_group.http_sg.id,
    ]
  }

  iam_instance_profile {
    arn = data.aws_iam_instance_profile.instance_profile.arn
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "cmtr-031bfa7b-instance"
      Terraform = "true"
      Project   = "cmtr-031bfa7b"
    }
  }

  tags = {
    Terraform = "true"
    Project   = "cmtr-031bfa7b"
  }
}

resource "aws_lb" "cmtr-031bfa7b-loadbalancer" {
  name               = "cmtr-031bfa7b-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.sglb.id]
  subnets            = data.aws_subnets.public.ids

  tags = {
    Terraform = "true"
    Project   = "cmtr-031bfa7b"
  }
}

resource "aws_lb_target_group" "cmtr-031bfa7b-tg" {
  name     = "cmtr-031bfa7b-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.cmtr-031bfa7b-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Terraform = "true"
    Project   = "cmtr-031bfa7b"
  }
}

resource "aws_lb_listener" "cmtr-031bfa7b-listener" {
  load_balancer_arn = aws_lb.cmtr-031bfa7b-loadbalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cmtr-031bfa7b-tg.arn
  }

  tags = {
    Terraform = "true"
    Project   = "cmtr-031bfa7b"
  }
}

resource "aws_autoscaling_group" "cmtr-031bfa7b-asg" {
  name                = "cmtr-031bfa7b-asg"
  vpc_zone_identifier = data.aws_subnets.public.ids
  desired_capacity    = 2
  min_size            = 1
  max_size            = 2

  launch_template {
    id      = aws_launch_template.cmtr-031bfa7b-template.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "cmtr-031bfa7b"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "cmtr-031bfa7b-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "cmtr-031bfa7b-attachment" {
  autoscaling_group_name = aws_autoscaling_group.cmtr-031bfa7b-asg.name
  lb_target_group_arn    = aws_lb_target_group.cmtr-031bfa7b-tg.arn
}
