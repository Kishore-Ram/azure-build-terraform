#!/bin/bash
# 1. Update OS
apt-get update -y && apt-get upgrade -y
apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

# 2. Install Git & Net-Tools
apt-get install -y git net-tools

# 3. Install Docker
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker azureuser # Allow default user to run docker

# 4. Install Azure CLI (Official Script)
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# 5. Install Kubectl v1.30 (Official Kubernetes Repo)
# Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# Add the Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl

echo "Installation Complete"