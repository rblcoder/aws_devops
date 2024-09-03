#!/bin/bash
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user
yum install -y httpd
systemctl start httpd
systemctl enable httpd