#!/bin/bash

# Stop Application Script for CodeDeploy
# This script stops the current deployment

echo "Stopping application..."

# Navigate to application directory
cd /opt/migrationai

# Stop all containers
echo "Stopping all containers..."
docker-compose down

# Force stop any remaining containers
echo "Force stopping any remaining containers..."
docker stop $(docker ps -q) 2>/dev/null || true

# Clean up containers
echo "Cleaning up containers..."
docker rm $(docker ps -aq) 2>/dev/null || true

echo "Application stopped successfully"
