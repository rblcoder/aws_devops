terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

# Data source to fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to fetch the default sg
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_default_subnet" "default" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

# Get latest Amazon Windows Server 2022 Ami
data "aws_ami" "windows-2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}

# Create EC2 instance
resource "aws_instance" "windows_server" {
  ami             = data.aws_ami.windows-2022.id
  instance_type   = var.instance_type
  key_name        = var.instance_key
  subnet_id       = aws_default_subnet.default.id
  security_groups = [data.aws_security_group.default.id]

}

output "public_ip" {
  value = aws_instance.windows_server.public_ip
}
