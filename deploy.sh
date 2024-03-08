#!/bin/bash

set -e

cd /home/next14-test

ls

LOG_FILE="/home/next14-test/deploy.log"

AWS_DEFAULT_REGION=$(jq -r '.[0].region' config.json)
ECR_REPOSITORY_URI=$(jq -r '.[0].repositoryUri' config.json)
CONTAINER_NAME=$(jq -r '.[0].name' config.json)
export IMAGE_URI=$(jq -r '.[0].imageUri' config.json)

echo "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" >> $LOG_FILE
echo "ECR_REPOSITORY_URI=$ECR_REPOSITORY_URI" >> $LOG_FILE
echo "CONTAINER_NAME=$CONTAINER_NAME" >> $LOG_FILE
echo "IMAGE_URI=$IMAGE_URI" >> $LOG_FILE

# 登录到Amazon ECR
# aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI} >> $LOG_FILE 2>&1

echo "容器名称: $CONTAINER_NAME"
echo "镜像URI: $IMAGE_URI"

# 拉取最新的镜像
docker pull ${IMAGE_URI} >> $LOG_FILE 2>&1

# 使用docker-compose重启服务
docker-compose down && docker-compose up -d >> $LOG_FILE 2>&1
