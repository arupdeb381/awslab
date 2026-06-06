#!/bin/bash

/usr/bin/hostnamectl set-hostname minikube-node


LOG_FILE="/home/ec2-user/minikube-install.log"

exec > >(tee -a ${LOG_FILE})
exec 2>&1

set -e

yum update -y
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

curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

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

sudo -u ec2-user /usr/local/bin/minikube start \
  --driver=docker \
  --cpus=2 \
  --memory=3000mb

echo "========================================"
echo "Cluster Status"
echo "========================================"

sudo -u ec2-user /usr/local/bin/kubectl get nodes

echo "========================================"
echo "Minikube installation completed"
echo "========================================"

echo "========================================"
echo "Configuring Remote Access"
echo "========================================"

/usr/sbin/usermod -aG docker ec2-user

# Get Minikube IP dynamically
MINIKUBE_IP=$(sudo -u ec2-user minikube ip)

# Install socat
yum install -y socat

# Forward EC2:8443 -> Minikube:8443
nohup socat TCP-LISTEN:8443,fork,reuseaddr TCP:${MINIKUBE_IP}:8443 >/dev/null 2>&1 &

# Get EC2 Public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Update kubeconfig
sudo -u ec2-user sed -i \
  "s|server: https://.*:8443|server: https://${PUBLIC_IP}:8443|g" \
  /home/ec2-user/.kube/config

echo "Remote API Endpoint:"
echo "https://${PUBLIC_IP}:8443"