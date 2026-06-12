#!/bin/bash

/usr/bin/hostnamectl set-hostname minikube-node

LOG_FILE="/home/ec2-user/minikube-install.log"

exec > >(tee -a ${LOG_FILE})
exec 2>&1

set -e

echo "========================================"
echo "Installing Docker"
echo "========================================"

yum install -y docker

systemctl enable docker
systemctl start docker

echo "========================================"
echo "Adding ec2-user to docker group"
echo "========================================"

usermod -aG docker ec2-user

echo "========================================"
echo "Installing kubectl"
echo "========================================"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version --client

echo "========================================"
echo "Installing Minikube"
echo "========================================"

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

install minikube-linux-amd64 /usr/local/bin/minikube

minikube version

echo "========================================"
echo "Starting Minikube"
echo "========================================"

sudo -u ec2-user /usr/local/bin/minikube start --driver=docker --cpus=2 --memory=3000mb 
echo "========================================"
echo "Cluster Status"
echo "========================================"

sudo -u ec2-user /usr/local/bin/kubectl get nodes
echo "========================================"
echo "Installation Complete"
echo "========================================"
