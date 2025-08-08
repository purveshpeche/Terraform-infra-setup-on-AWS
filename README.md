# MigrationAI - AWS Infrastructure with Terraform

## 🏗️ Infrastructure Overview

This Terraform configuration creates a complete production-ready AWS infrastructure for MigrationAI in the `us-west-2` (Oregon) region. All resources are deployed within a custom VPC with proper networking, security, and connectivity.

## 🗺️ Architecture Flow

```
GitHub Repository
       ↓
   CodePipeline
       ↓
   CodeBuild (Builds Docker Images)
       ↓
   ECR Repositories (Stores Images)
       ↓
   ┌─────────────────┬─────────────────┬─────────────────┐
   ↓                 ↓                 ↓                 ↓
EC2 Instances    Lambda Functions  App Runner      SQS Queues
   ↓                 ↓                 ↓                 ↓
Docker Containers  SQS Triggers    Web Services   Message Processing
```

## 🔗 Detailed Service Connections

### 1. **VPC & Networking** (All services run within VPC)
- **VPC**: `migrationai-prod-vpc` (10.0.0.0/16)
- **Public Subnets**: 2 subnets across us-west-2a and us-west-2b
- **Private Subnets**: 2 subnets across us-west-2a and us-west-2b
- **Internet Gateway**: For public internet access
- **NAT Gateways**: For private subnet internet access
- **Route Tables**: Separate routing for public and private subnets

### 2. **Security Groups** (Controlled access between services)
- **Backend SG**: Allows SSH (22), HTTP (80), HTTPS (443) from 0.0.0.0/0
- **Redis SG**: Allows Redis (6379) from backend security group
- **All services are connected through security groups**

### 3. **EC2 Instances** (Application Servers)
- **Instance 1**: `migrationai-backend` (t3a.large, 153GB)
- **Instance 2**: `migrationai-tfp` (t3a.large, 153GB)
- **Location**: Private subnets for security
- **SSH Access**: Via AWS Systems Manager Session Manager
- **Docker**: Pre-installed and configured
- **IAM Role**: For ECR access and Systems Manager

### 4. **ECR Repositories** (Container Registry)
- **15 Repositories** for different services:
  - Frontend: `prod/migrationai-frontend`, `prod/migrationai-admin-frontend`
  - Backend: `prod/migrationai-backend-api`, `prod/migrationai-admin-backend`, `prod/migrationai-tfp`
  - Workers: 10 worker containers for different business functions

### 5. **SQS Queues** (Message Processing)
- **13 Standard Queues** for different business functions
- **13 Dead Letter Queues** (DLQs) for failed message handling
- **Visibility Timeout**: 120 seconds
- **Redrive Policy**: 3 retries before moving to DLQ
- **All queues are connected to Lambda functions**

### 6. **Lambda Functions** (Serverless Processing)
- **13 Functions** corresponding to each SQS queue
- **Docker Images**: All functions use container images from ECR
- **SQS Triggers**: Automatic invocation when messages arrive
- **Environment Variables**: Queue URLs for processing
- **Timeout**: 300 seconds, Memory: 512MB

### 7. **App Runner Services** (Web Applications)
- **Frontend Service**: `migrationai-frontend`
- **Admin Frontend Service**: `migrationai-admin-frontend`
- **Container Images**: From ECR repositories
- **Auto-scaling**: Based on traffic
- **HTTPS**: Automatic SSL certificates

### 8. **MemoryDB Redis** (Caching)
- **Cluster**: `migrationai-redis-cache`
- **Node Type**: db.t4.micro
- **Port**: 6379
- **Security**: Only accessible from backend security group
- **Subnet Group**: Placed in private subnets

### 9. **S3 Bucket** (File Storage)
- **Bucket**: `migrationai`
- **Versioning**: Enabled
- **Encryption**: Server-side encryption
- **Lifecycle**: Automatic transitions to IA, Glacier, Deep Archive
- **Access**: Through IAM roles and policies

### 10. **CI/CD Pipeline** (Automated Deployment)
- **Source**: GitHub repository
- **Build**: CodeBuild with Docker image building
- **Deploy**: 
  - CodeDeploy for EC2 instances
  - Lambda function updates
  - App Runner service updates

## 🔄 Detailed Flow Explanation

### **Development & Deployment Flow**

1. **Code Push** → GitHub repository
2. **CodePipeline Trigger** → Automatically starts pipeline
3. **CodeBuild Process**:
   - Pulls code from GitHub
   - Builds Docker images for all services
   - Pushes images to ECR repositories
   - Creates deployment artifacts
4. **Deployment Stage**:
   - **EC2**: CodeDeploy updates Docker containers on instances
   - **Lambda**: Updates function code with new images
   - **App Runner**: Starts new deployment with updated images

### **Application Runtime Flow**

1. **User Request** → App Runner Services (Frontend)
2. **Frontend** → Backend API (EC2 instances)
3. **Backend Processing**:
   - **Database Operations** → Direct database connections
   - **File Operations** → S3 bucket interactions
   - **Caching** → MemoryDB Redis cluster
   - **Async Tasks** → SQS queue messages
4. **Worker Processing**:
   - **SQS Messages** → Lambda function triggers
   - **Lambda Execution** → Processes business logic
   - **Results** → Back to SQS or direct to services

### **Message Processing Flow**

1. **Business Event** → SQS Queue (e.g., `prod-migrationai-contacts`)
2. **Lambda Trigger** → Automatic invocation of corresponding Lambda
3. **Processing** → Lambda function processes the message
4. **Success** → Message deleted from queue
5. **Failure** → Message moved to DLQ after 3 retries

## 🔐 Security & Connectivity

### **VPC Isolation**
- All resources run within the custom VPC
- Private subnets for sensitive resources (EC2, MemoryDB, Lambda)
- Public subnets only for load balancers and NAT gateways
- Security groups control all traffic between services

### **Access Control**
- **EC2 Instances**: SSH via AWS Systems Manager (no public IPs)
- **Lambda Functions**: IAM roles with minimal permissions
- **App Runner**: IAM roles for ECR access
- **SQS**: IAM policies for queue access
- **S3**: Bucket policies and IAM roles

### **Data Protection**
- **Encryption**: All data encrypted at rest and in transit
- **Backup**: S3 versioning and lifecycle policies
- **Monitoring**: CloudWatch logs for all services
- **Audit**: CloudTrail for API calls

## 🚀 Deployment Instructions

### **Prerequisites**
```bash
# Install Terraform
sudo snap install terraform

# Configure AWS CLI
aws configure

# Install AWS Systems Manager Session Manager plugin
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
```

### **Deployment Steps**
```bash
# 1. Initialize Terraform
terraform init

# 2. Review the plan
terraform plan

# 3. Apply the infrastructure
terraform apply

# 4. Connect to EC2 instances (via Systems Manager)
aws ssm start-session --target i-1234567890abcdef0
```

## 📊 Cost Estimation

### **Monthly Costs (us-west-2)**
- **EC2 Instances**: ~$120 (2x t3a.large)
- **Lambda Functions**: ~$50 (13 functions, moderate usage)
- **App Runner**: ~$100 (2 services)
- **MemoryDB Redis**: ~$30 (db.t4.micro)
- **SQS**: ~$10 (26 queues, moderate usage)
- **S3**: ~$5 (moderate storage)
- **NAT Gateway**: ~$45 (2 gateways)
- **Data Transfer**: ~$20
- **Total Estimated**: ~$380/month

## 🔧 Configuration Files

### **Terraform Files**
- `main.tf` - VPC, networking, security groups
- `variables.tf` - Input variables
- `terraform.tfvars` - Variable values
- `outputs.tf` - Output values
- `ecr.tf` - ECR repositories
- `s3.tf` - S3 bucket configuration
- `memorydb.tf` - Redis cluster
- `sqs.tf` - SQS queues and DLQs
- `lambda.tf` - Lambda functions and triggers
- `ec2.tf` - EC2 instances and IAM roles
- `apprunner.tf` - App Runner services
- `codepipeline.tf` - CI/CD pipeline

### **Build Configuration**
- `buildspec.yml` - CodeBuild build specification
- `lambda_functions/` - Lambda function source code

## 🛠️ Maintenance & Monitoring

### **Logging**
- **CloudWatch Logs**: All Lambda functions and CodeBuild
- **EC2 Logs**: System and application logs
- **App Runner Logs**: Application logs

### **Monitoring**
- **CloudWatch Metrics**: CPU, memory, network
- **SQS Metrics**: Queue depth, processing time
- **Lambda Metrics**: Invocation count, duration, errors

### **Scaling**
- **App Runner**: Automatic scaling based on traffic
- **Lambda**: Automatic scaling based on SQS queue depth
- **EC2**: Manual scaling (can be automated with CloudWatch alarms)

## 🔄 Update Process

1. **Code Changes** → Push to GitHub
2. **Pipeline Trigger** → Automatic build and deployment
3. **Rollback** → Previous versions available in ECR
4. **Monitoring** → Check CloudWatch logs and metrics

## 🚨 Troubleshooting

### **Common Issues**
- **EC2 Connection**: Use Systems Manager Session Manager
- **Lambda Errors**: Check CloudWatch logs
- **SQS Issues**: Check DLQ for failed messages
- **App Runner**: Check service logs and health checks

### **Useful Commands**
```bash
# Check Lambda function status
aws lambda get-function --function-name migrationai-contacts

# Check SQS queue depth
aws sqs get-queue-attributes --queue-url https://sqs.us-west-2.amazonaws.com/...

# Check App Runner service status
aws apprunner describe-service --service-arn arn:aws:apprunner:us-west-2:...

# Connect to EC2 instance
aws ssm start-session --target i-1234567890abcdef0
```

## 📞 Support

For issues or questions:
1. Check CloudWatch logs first
2. Review security group rules
3. Verify IAM permissions
4. Check VPC connectivity

---

**MigrationAI Infrastructure** - Production-ready AWS setup with full CI/CD pipeline, containerized applications, and serverless processing capabilities. 