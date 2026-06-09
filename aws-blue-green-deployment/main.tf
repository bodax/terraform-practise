provider "aws" {
  region = var.region
}

# Data sources for existing networking resources
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}

data "aws_subnet" "public1" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-public-subnet1"]
  }
}

data "aws_subnet" "public2" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-public-subnet2"]
  }
}

data "aws_security_group" "ssh" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-sg-ssh"]
  }
}

data "aws_security_group" "http" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-sg-http"]
  }
}

data "aws_security_group" "lb" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-sg-lb"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Target Groups
resource "aws_lb_target_group" "blue" {
  name     = "${var.prefix}-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

  tags = {
    Name        = "${var.prefix}-blue-tg"
    Environment = "blue"
  }
}

resource "aws_lb_target_group" "green" {
  name     = "${var.prefix}-green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

  tags = {
    Name        = "${var.prefix}-green-tg"
    Environment = "green"
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.lb.id]
  subnets            = [data.aws_subnet.public1.id, data.aws_subnet.public2.id]

  tags = {
    Name = "${var.prefix}-lb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = var.blue_weight
      }

      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = var.green_weight
      }
    }
  }
}

# Launch Templates
resource "aws_launch_template" "blue" {
  name = "${var.prefix}-blue-template"

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    data.aws_security_group.ssh.id,
    data.aws_security_group.http.id,
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Blue Environment</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.prefix}-blue-instance"
      Environment = "blue"
    }
  }

  tags = {
    Name        = "${var.prefix}-blue-template"
    Environment = "blue"
  }
}

resource "aws_launch_template" "green" {
  name = "${var.prefix}-green-template"

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    data.aws_security_group.ssh.id,
    data.aws_security_group.http.id,
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Green Environment</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.prefix}-green-instance"
      Environment = "green"
    }
  }

  tags = {
    Name        = "${var.prefix}-green-template"
    Environment = "green"
  }
}

# Auto Scaling Groups
resource "aws_autoscaling_group" "blue" {
  name                = "${var.prefix}-blue-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = [data.aws_subnet.public1.id, data.aws_subnet.public2.id]
  target_group_arns   = [aws_lb_target_group.blue.arn]

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-blue-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "blue"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green" {
  name                = "${var.prefix}-green-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = [data.aws_subnet.public1.id, data.aws_subnet.public2.id]
  target_group_arns   = [aws_lb_target_group.green.arn]

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-green-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "green"
    propagate_at_launch = true
  }
}
