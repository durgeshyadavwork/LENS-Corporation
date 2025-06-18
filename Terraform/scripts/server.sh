#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user

# Docker login - use SSM or replace with actual
echo "<DOCKER_PASSWORD>" | docker login -u "<DOCKER_USERNAME>" --password-stdin

docker stop app || true
docker rm app || true

docker pull dugreshyadav/lens_corporation:${IMAGE_TAG}
docker run -d --name app -p 80:3000 dugreshyadav/lens_corporation:${IMAGE_TAG}
