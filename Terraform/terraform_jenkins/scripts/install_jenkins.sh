#! /bin/bash

sudo yum update -y

sudo yum install -y git

sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker


#Download
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

#import key

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto-devel

#sudo yum install -y jenkins java-1.8.0-openjdk-devel

sudo yum install -y jenkins


sudo systemctl daemon-reload

# Start Jenkins
sudo systemctl start jenkins


sudo systemctl enable jenkins

sudo usermod -aG docker jenkins


sudo systemctl restart jenkins