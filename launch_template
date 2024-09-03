provider "aws" {
  region = "us-east-1"  
}

resource "aws_launch_template" "example" {
  name = "httpd-server-launch-template"
  image_id = "ami-02c21308fed24a8ab"  # Amazon Linux 2 AMI

  instance_type = "t2.micro" 

  user_data = filebase64("init.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "httpd-project"
    }
  }
}
