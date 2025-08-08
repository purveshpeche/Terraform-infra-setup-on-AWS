#!/bin/bash

# Before Install Script for CodeDeploy
# This script runs before the new deployment is installed

echo "Starting before_install script..."

# Stop existing containers
echo "Stopping existing containers..."
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

# Clean up old images (optional - uncomment if needed)
# docker image prune -f

# Pull latest images from ECR
echo "Pulling latest images from ECR..."
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com

# Pull all required images
docker pull $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/prod/migrationai-backend-api:latest
docker pull $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/prod/migrationai-admin-backend:latest
docker pull $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/prod/migrationai-tfp:latest

echo "Before install script completed successfully"
