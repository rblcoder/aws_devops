provider "aws" {
  region = "us-east-1"  
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "vpc-id"  # Replace with your VPC ID

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

resource "aws_launch_template" "example" {
  name = "httpd-server-launch-template"
  image_id = "ami-02c21308fed24a8ab"  # Amazon Linux 2 AMI

  instance_type = "t2.micro" 
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = filebase64("init.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "httpd-project"
    }
  }
}
