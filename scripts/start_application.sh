#!/bin/bash

# Start Application Script for CodeDeploy
# This script starts the new deployment

echo "Starting application..."

# Navigate to application directory
cd /opt/migrationai

# Start services using docker-compose
echo "Starting services with docker-compose..."
docker-compose up -d

# Wait for services to be healthy
echo "Waiting for services to be healthy..."
sleep 30

# Health checks
echo "Performing health checks..."

# Check backend API
if curl -f http://localhost:3000/health; then
    echo "✅ Backend API is healthy"
else
    echo "❌ Backend API health check failed"
    exit 1
fi

# Check admin backend
if curl -f http://localhost:3001/health; then
    echo "✅ Admin Backend is healthy"
else
    echo "❌ Admin Backend health check failed"
    exit 1
fi

# Check TFP service
if curl -f http://localhost:3002/health; then
    echo "✅ TFP Service is healthy"
else
    echo "❌ TFP Service health check failed"
    exit 1
fi

echo "All services are healthy and running!"
echo "Application started successfully"
