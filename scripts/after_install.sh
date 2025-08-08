#!/bin/bash

# After Install Script for CodeDeploy
# This script runs after the new deployment is installed

echo "Starting after_install script..."

# Copy deployment artifacts to application directory
echo "Copying deployment artifacts..."
cp -r /opt/migrationai/* /opt/migrationai/

# Load environment variables from .env file
if [ -f /opt/migrationai/.env ]; then
    echo "Loading environment variables..."
    export $(cat /opt/migrationai/.env | xargs)
fi

# Set default environment variables if not set
export AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID:-$(aws sts get-caller-identity --query Account --output text)}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}
export REDIS_URL=${REDIS_URL:-"redis://your-memorydb-endpoint:6379"}
export CONTACTS_QUEUE_URL=${CONTACTS_QUEUE_URL:-"https://sqs.us-west-2.amazonaws.com/$AWS_ACCOUNT_ID/prod-migrationai-contacts"}
export PROJECTS_QUEUE_URL=${PROJECTS_QUEUE_URL:-"https://sqs.us-west-2.amazonaws.com/$AWS_ACCOUNT_ID/prod-migrationai-projects"}

# Replace placeholders in docker-compose.yml with actual values
echo "Configuring docker-compose.yml with environment variables..."
sed -i "s/\${AWS_ACCOUNT_ID}/$AWS_ACCOUNT_ID/g" /opt/migrationai/docker-compose.yml
sed -i "s/\${AWS_DEFAULT_REGION}/$AWS_DEFAULT_REGION/g" /opt/migrationai/docker-compose.yml
sed -i "s|\${REDIS_URL}|$REDIS_URL|g" /opt/migrationai/docker-compose.yml
sed -i "s|\${CONTACTS_QUEUE_URL}|$CONTACTS_QUEUE_URL|g" /opt/migrationai/docker-compose.yml
sed -i "s|\${PROJECTS_QUEUE_URL}|$PROJECTS_QUEUE_URL|g" /opt/migrationai/docker-compose.yml

echo "Deployment artifacts configured successfully"

echo "After install script completed successfully"
