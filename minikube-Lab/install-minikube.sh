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
echo "Enabling Dashboard"
echo "========================================"

sudo -u ec2-user /usr/local/bin/minikube addons enable dashboard

echo "Waiting for dashboard pods..."
sleep 30

echo "========================================"
echo "Creating Dashboard Admin User"
echo "========================================"

cat <<EOF | sudo -u ec2-user /usr/local/bin/kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
name: admin-user
namespace: kubernetes-dashboard
EOF

cat <<EOF | sudo -u ec2-user /usr/local/bin/kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
name: admin-user
roleRef:
apiGroup: rbac.authorization.k8s.io
kind: ClusterRole
name: cluster-admin
subjects:

* kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
  EOF

echo "========================================"
echo "Exposing Dashboard"
echo "========================================"

sudo -u ec2-user /usr/local/bin/kubectl patch svc kubernetes-dashboard -n kubernetes-dashboard --type='json' -p='[{"op":"replace","path":"/spec/type","value":"NodePort"}, {"op":"add","path":"/spec/ports/0/nodePort","value":30080} ]' || true

echo "========================================"
echo "Generating Dashboard Token"
echo "========================================"

TOKEN=$(sudo -u ec2-user /usr/local/bin/kubectl -n kubernetes-dashboard create token admin-user)

PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

cat > /home/ec2-user/dashboard-info.txt <<EOF

========================================
MINIKUBE DASHBOARD ACCESS
=========================

Dashboard URL:

https://${PUBLIC_IP}:30080

Login Token:

${TOKEN}

========================================

EOF

chown ec2-user:ec2-user /home/ec2-user/dashboard-info.txt

echo "========================================"
echo "Installation Complete"
echo "========================================"

echo ""
echo "Dashboard Details Saved To:"
echo "/home/ec2-user/dashboard-info.txt"
echo ""
cat /home/ec2-user/dashboard-info.txt
