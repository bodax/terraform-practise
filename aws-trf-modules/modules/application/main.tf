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
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd

    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
    LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
    INSTANCE_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)

    cat > /var/www/html/index.html <<HTML
    <html>
    <head><title>Instance Info</title></head>
    <body>
    <h1>EC2 Instance Info</h1>
    <p><b>Instance ID:</b> $INSTANCE_ID</p>
    <p><b>Availability Zone:</b> $AZ</p>
    <p><b>Local IP:</b> $LOCAL_IP</p>
    <p><b>Instance Type:</b> $INSTANCE_TYPE</p>
    </body>
    </html>
    HTML
  EOF
}

resource "aws_launch_template" "this" {
  name          = var.launch_template_name
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  network_interfaces {
    security_groups             = [var.ssh_sg_id, var.private_http_sg_id]
    associate_public_ip_address = true
    delete_on_termination       = true
  }

  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.launch_template_name
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                = var.asg_name
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}
