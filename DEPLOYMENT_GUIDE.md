# 🚀 MigrationAI Infrastructure Deployment Guide

## ✅ **Configuration Status: READY TO DEPLOY**

All Terraform files have been validated and are ready for deployment to **us-west-2 (Oregon)**.

## 📋 **Pre-Deployment Checklist**

### **1. Prerequisites Installation**

```bash
# Install Terraform
sudo snap install terraform

# Install AWS CLI (if not already installed)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### **2. AWS Configuration**

```bash
# Configure AWS credentials
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region (us-west-2), and output format (json)
```

### **3. SSH Key Setup (Optional)**

If you want to use your own SSH key for EC2 instances:

```bash
# Generate SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/migrationai_key -N ""

# Update the public key in ec2.tf
# Replace the placeholder key with your actual public key
```

## 🏗️ **Infrastructure Components**

### **Networking (us-west-2)**
- ✅ VPC: `migrationai-prod-vpc` (10.0.0.0/16)
- ✅ 2 Public Subnets (us-west-2a, us-west-2b)
- ✅ 2 Private Subnets (us-west-2a, us-west-2b)
- ✅ Internet Gateway & NAT Gateways
- ✅ Security Groups

### **Container Registry**
- ✅ 15 ECR Repositories for all containers

### **Storage & Caching**
- ✅ S3 Bucket: `migrationai` (encrypted, versioned)
- ✅ MemoryDB Redis Cluster

### **Messaging**
- ✅ 13 SQS Queues + 13 Dead Letter Queues

### **Serverless & Compute**
- ✅ 13 Lambda Functions
- ✅ 2 EC2 Instances (t3a.large)
- ✅ 2 App Runner Services

## 🚀 **Deployment Steps**

### **Step 1: Initialize Terraform**
```bash
terraform init
```

### **Step 2: Plan the Deployment**
```bash
terraform plan
```
This will show you exactly what resources will be created.

### **Step 3: Apply the Configuration**
```bash
terraform apply
```
Type `yes` when prompted to confirm.

### **Step 4: Verify Deployment**
```bash
terraform output
```

## 💰 **Cost Estimation**

**Monthly costs for production:**
- EC2 Instances: ~$60/month
- NAT Gateways: ~$45/month
- MemoryDB: ~$30/month
- Lambda: ~$10-50/month
- SQS: ~$5-20/month
- S3: ~$5-20/month
- App Runner: ~$20-50/month
- ECR: ~$5-15/month

**Total: $180-300/month**

## 🔐 **Security Features**

- ✅ Private subnets with NAT gateways
- ✅ Encrypted S3 bucket with public access blocked
- ✅ Encrypted EC2 volumes
- ✅ Security groups with least privilege
- ✅ IAM roles with minimal permissions

## 📊 **Post-Deployment**

### **Access Your Resources**

1. **EC2 Instances**: Use SSH with the key pair
2. **S3 Bucket**: Access via AWS Console or CLI
3. **ECR Repositories**: Push your container images
4. **App Runner Services**: Access via provided URLs
5. **Lambda Functions**: Monitor via CloudWatch

### **Monitoring**

```bash
# Check resource status
terraform show

# List all resources
terraform state list

# Get specific outputs
terraform output vpc_id
terraform output ecr_repository_urls
terraform output apprunner_service_urls
```

## 🧹 **Cleanup (When Done)**

```bash
# Destroy all resources
terraform destroy
```

## ⚠️ **Important Notes**

1. **SSH Key**: The EC2 configuration uses a placeholder SSH key. Replace it with your actual key before deployment.

2. **Lambda Functions**: The Lambda functions use placeholder code. Replace with your actual business logic.

3. **ECR Images**: You'll need to push your container images to the ECR repositories.

4. **Database**: Consider adding RDS for persistent data storage.

5. **Monitoring**: Add CloudWatch alarms and logging for production use.

## 🆘 **Troubleshooting**

### **Common Issues**

1. **AWS Credentials**: Ensure your AWS credentials have sufficient permissions
2. **Region**: All resources will be created in us-west-2
3. **Costs**: Monitor your AWS billing dashboard
4. **Security Groups**: Adjust security group rules as needed

### **Useful Commands**

```bash
# Validate configuration
terraform validate

# Format code
terraform fmt

# Check plan without applying
terraform plan -out=tfplan

# Apply specific plan
terraform apply tfplan
```

## 📞 **Support**

If you encounter issues:
1. Check the Terraform error messages
2. Verify AWS credentials and permissions
3. Ensure all required files are present
4. Review the AWS Console for resource status

---

**🎉 Your MigrationAI infrastructure is ready to deploy!** 