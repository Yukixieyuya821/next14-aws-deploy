#!/bin/bash

set -e

LOG_FILE="/var/log/deploy.log"

export AWS_DEFAULT_REGION=$(jq -r '.[0].region' config.json) >> $LOG_FILE 2>&1
export ECR_REPOSITORY_URI=$(jq -r '.[0].repositoryUri' config.json) >> $LOG_FILE 2>&1
export CONTAINER_NAME=$(jq -r '.[0].name' config.json) >> $LOG_FILE 2>&1
export IMAGE_URI=$(jq -r '.[0].imageUri' config.json) >> $LOG_FILE 2>&1

# 登录到Amazon ECR
aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI} >> $LOG_FILE 2>&1

echo "容器名称: $CONTAINER_NAME"
echo "镜像URI: $IMAGE_URI"

# 拉取最新的镜像
docker pull ${IMAGE_URI} >> $LOG_FILE 2>&1

# 使用docker-compose重启服务
docker-compose down && docker-compose up -d >> $LOG_FILE 2>&1
