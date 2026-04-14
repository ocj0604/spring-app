#!/bin/bash

set -e

echo "=============================="
echo "EC2 초기 세팅 시작"
echo "=============================="

# 1. 패키지 업데이트
echo "시스템 업데이트"
sudo apt-get update -y
sudo apt-get upgrade -y

# 2. 필수 패키지 설치
echo "기본 패키지 설치"
sudo apt-get install -y \
    git \
    curl \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# 3. Docker 설치
echo "Docker 설치"

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker 권한 설정
sudo usermod -aG docker ubuntu
newgrp docker

# Docker 실행 확인
docker --version

# 4. AWS CLI 설치 (ECR 로그인용)
echo "AWS CLI 설치"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws --version

# 5. 시간대 설정 (KST)
echo "시간대 설정"
sudo timedatectl set-timezone Asia/Seoul

# 6. 스왑 설정 (메모리 부족 방지)
echo "Swap 설정 (1GB)"

sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 8. 완료
echo "=============================="
echo "EC2 초기 세팅 완료!"
echo "=============================="