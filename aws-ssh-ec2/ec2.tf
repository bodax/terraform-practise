data "aws_vpc" "cmtr-031bfa7b-vpc" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-031bfa7b-vpc"]
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "vpc-id"
    values = ["vpc-08a7abf019364ad05"]
  }

  filter {
    name   = "cidr-block"
    values = ["10.0.1.0/24"]
  }
}

data "aws_security_group" "cmtr-031bfa7b-sg" {
  filter {
    name   = "group-name"
    values = ["cmtr-031bfa7b-sg"]
  }

  vpc_id = data.aws_vpc.cmtr-031bfa7b-vpc.id
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

resource "aws_instance" "cmtr-031bfa7b-ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id = data.aws_subnet.public.id

  vpc_security_group_ids = [
    data.aws_security_group.cmtr-031bfa7b-sg.id
  ]

  key_name = aws_key_pair.cmtr-031bfa7b-keypair.key_name

  associate_public_ip_address = true

  tags = {
    Project = "epam-tf-lab"
    ID      = "cmtr-031bfa7b"
  }
}