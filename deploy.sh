#!/bin/bash
set -e

export AWS_DEFAULT_REGION=$(jq -r '.[0].region' config.json)
export ECR_REPOSITORY_URI=$(jq -r '.[0].repositoryUri' config.json)
export CONTAINER_NAME=$(jq -r '.[0].name' config.json)
export IMAGE_URI=$(jq -r '.[0].imageUri' config.json)

# 登录到Amazon ECR
aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}

echo "容器名称: $CONTAINER_NAME"
echo "镜像URI: $IMAGE_URI"

# 拉取最新的镜像
docker pull ${IMAGE_URI}

# 使用docker-compose重启服务
docker-compose down && docker-compose up -d
