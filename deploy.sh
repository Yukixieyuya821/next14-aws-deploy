#!/bin/bash
set -e

# 登录到Amazon ECR
aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}

export CONTAINER_NAME=$(jq -r '.[0].name' imagedefinitions.json)
export IMAGE_URI=$(jq -r '.[0].imageUri' imagedefinitions.json)

echo "容器名称: $CONTAINER_NAME"
echo "镜像URI: $IMAGE_URI"

# 拉取最新的镜像
docker pull ${IMAGE_URI}

# 使用docker-compose重启服务
docker-compose down && docker-compose up -d
