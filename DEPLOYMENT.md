# 🚀 MigrationAI Application Deployment Guide

## 📋 Overview

This guide explains how to deploy the MigrationAI application code through the AWS CodePipeline infrastructure.

## 🏗️ Application Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend API   │    │   Lambda        │
│   (App Runner)  │◄──►│   (EC2)         │◄──►│   Workers       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   S3 Storage    │    │   MemoryDB      │    │   SQS Queues    │
│   (Files)       │    │   (Cache)       │    │   (Messages)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🔄 CI/CD Pipeline Flow

### 1. **Source Stage** (GitHub)
- Monitors your GitHub repository for changes
- Triggers pipeline on push to `main` branch
- **Repository**: `your-github-username/migrationai-repo`

### 2. **Build Stage** (CodeBuild)
- Builds all Docker images from source code
- Pushes images to ECR repositories
- Creates deployment artifacts

### 3. **Deploy Stage** (Multiple Targets)
- **EC2 Instances**: CodeDeploy deploys to EC2
- **Lambda Functions**: Updates function code
- **App Runner**: Deploys frontend applications

## 📁 Application Structure

```
migrationai-repo/
├── lambda/                    # Lambda Worker Functions
│   ├── contacts/
│   │   ├── Dockerfile
│   │   ├── index.js
│   │   └── package.json
│   ├── projects/
│   ├── sections/
│   └── ... (13 total)
├── backend/                   # Backend Services
│   ├── api/
│   │   ├── Dockerfile
│   │   ├── server.js
│   │   └── package.json
│   ├── admin/
│   └── tfp/
├── frontend/                  # Frontend Applications
│   ├── main/
│   │   ├── Dockerfile
│   │   ├── src/
│   │   └── package.json
│   └── admin/
├── scripts/                   # Deployment Scripts
│   ├── before_install.sh
│   ├── after_install.sh
│   ├── start_application.sh
│   └── stop_application.sh
└── buildspec.yml             # CodeBuild Configuration
```

## 🐳 Docker Images Built

### **Lambda Workers** (13 containers)
- `migrationai-backend-worker-contacts`
- `migrationai-backend-worker-projects`
- `migrationai-backend-worker-sections`
- `migrationai-backend-worker-notes`
- `migrationai-backend-worker-calendar`
- `migrationai-backend-worker-tasks`
- `migrationai-backend-worker-billing-items`
- `migrationai-backend-worker-project-funds`
- `migrationai-backend-worker-billing-invoice`
- `migrationai-backend-worker-payment`
- `migrationai-backend-worker-project-email`
- `migrationai-backend-worker-document`
- `migrationai-backend-worker-jobs`

### **Backend Services** (3 containers)
- `migrationai-backend-api`
- `migrationai-admin-backend`
- `migrationai-tfp`

### **Frontend Services** (2 containers)
- `migrationai-frontend`
- `migrationai-admin-frontend`

## 📦 Deployment Artifacts

CodeBuild creates the following artifacts:

```
deployment/
├── appspec.yml              # CodeDeploy configuration
├── docker-compose.yml       # Container orchestration
├── .env                     # Environment variables
├── taskdef.json            # ECS task definition
├── imagedefinitions.json   # ECS image definitions
├── deployment-manifest.json # Deployment metadata
└── scripts/                # Deployment scripts
    ├── before_install.sh
    ├── after_install.sh
    ├── start_application.sh
    └── stop_application.sh
```

## 🔧 Deployment Process

### **EC2 Deployment** (CodeDeploy)

1. **Before Install**:
   - Stop existing containers
   - Pull latest images from ECR

2. **After Install**:
   - Copy deployment artifacts
   - Configure environment variables
   - Update docker-compose.yml

3. **Application Start**:
   - Start containers with docker-compose
   - Perform health checks
   - Verify all services are running

4. **Application Stop**:
   - Gracefully stop containers
   - Clean up resources

### **Lambda Deployment**

- Updates function code from ECR images
- Maintains existing configuration
- Zero-downtime updates

### **App Runner Deployment**

- Deploys new container versions
- Automatic health checks
- Blue-green deployment

## 🌐 Service Endpoints

After deployment, services will be available at:

### **EC2 Services** (Private subnets)
- **Backend API**: `http://backend-ec2:3000`
- **Admin Backend**: `http://backend-ec2:3001`
- **TFP Service**: `http://tfp-ec2:3002`

### **App Runner Services** (Public)
- **Frontend**: `https://migrationai-frontend.apprunner.region.amazonaws.com`
- **Admin Frontend**: `https://migrationai-admin-frontend.apprunner.region.amazonaws.com`

### **Lambda Functions** (Serverless)
- Triggered by SQS messages
- Process business logic asynchronously

## 🔍 Monitoring & Health Checks

### **Health Check Endpoints**
- Backend API: `GET /health`
- Admin Backend: `GET /health`
- TFP Service: `GET /health`

### **CloudWatch Monitoring**
- Application logs
- Performance metrics
- Error tracking

### **SQS Monitoring**
- Queue depth
- Message processing
- Dead letter queue monitoring

## 🚨 Troubleshooting

### **Common Issues**

1. **Build Failures**:
   - Check Docker build logs
   - Verify dependencies in package.json
   - Ensure Dockerfile syntax is correct

2. **Deployment Failures**:
   - Check CodeDeploy logs
   - Verify EC2 instance connectivity
   - Check IAM permissions

3. **Service Health Issues**:
   - Check container logs: `docker logs <container-name>`
   - Verify environment variables
   - Check network connectivity

### **Debug Commands**

```bash
# Check container status
docker ps -a

# View container logs
docker logs migrationai-backend-api

# Check service health
curl http://localhost:3000/health

# View deployment logs
tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log
```

## 🔐 Security Considerations

- All services run within VPC
- Private subnets for backend services
- IAM roles for least privilege access
- Security groups control network access
- HTTPS for public endpoints

## 📈 Scaling

- **App Runner**: Auto-scales based on traffic
- **Lambda**: Scales automatically with message volume
- **EC2**: Manual scaling through Auto Scaling Groups
- **SQS**: Handles message queuing and processing

## 🔄 Rollback Process

If deployment fails:
1. CodeDeploy automatically rolls back to previous version
2. Lambda functions maintain previous version
3. App Runner maintains previous deployment
4. All rollbacks are logged and monitored

## 📞 Support

For deployment issues:
1. Check CloudWatch logs
2. Review CodePipeline execution history
3. Verify infrastructure with Terraform
4. Contact DevOps team for assistance

---

**Next Steps**: 
1. Push your application code to GitHub
2. Update the pipeline configuration with your repository details
3. Trigger the first deployment
4. Monitor the deployment process
5. Verify all services are running correctly
