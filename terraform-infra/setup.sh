#!/bin/bash

echo "Installing AWS CLI, Tmux and Git...."

apt update && apt install awscli tmux git -y

sleep 3

cd /home/ubuntu && git clone https://github.com/bijaypachhai/dotfiles.git && cp /home/ubuntu/dotfiles/ghostty/.tmux.conf /home/ubuntu/.tmux.conf && cp /home/ubuntu/dotfiles/ghostty/ghostty-info /home/ubuntu/ghostty-info && rm -r /home/ubuntu/dotfiles

sleep 2

cd /home/ubuntu && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 && chown ubuntu:ubuntu /home/ubuntu/get_helm.sh && chmod 700 /home/ubuntu/get_helm.sh

sleep 2

#######################################
#### Installing EKSCTL #####
#######################################
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /home/ubuntu && rm eksctl_$PLATFORM.tar.gz

install -m 0755 /home/ubuntu/eksctl /usr/local/bin && rm /home/ubuntu/eksctl

sleep 2

##########################################
###### Installing kubectl ###########
##########################################

cd /home/ubuntu && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl