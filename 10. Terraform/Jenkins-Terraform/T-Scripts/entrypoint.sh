#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io
sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker
sudo usermod -aG docker ubuntu
sudo systemctl restart docker
docker run -d -p 8080:8080 adijaiswal/petsore
