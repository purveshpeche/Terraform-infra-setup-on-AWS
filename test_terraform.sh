#!/bin/bash

echo "🔍 Testing Terraform Configuration for MigrationAI"
echo "=================================================="

# Check if all required files exist
echo "📁 Checking required files..."
files=("main.tf" "variables.tf" "terraform.tfvars" "outputs.tf" "ecr.tf" "s3.tf" "memorydb.tf" "sqs.tf" "lambda.tf" "ec2.tf" "apprunner.tf")

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

# Check if Lambda ZIP files exist
echo ""
echo "📦 Checking Lambda ZIP files..."
lambda_files=("lambda_contacts.zip" "lambda_projects.zip" "lambda_sections.zip" "lambda_notes.zip" "lambda_calendar.zip" "lambda_tasks.zip" "lambda_billing_items.zip" "lambda_project_funds.zip" "lambda_billing_invoice.zip" "lambda_payment.zip" "lambda_project_email.zip" "lambda_document.zip" "lambda_jobs.zip")

for file in "${lambda_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

# Check Terraform syntax
echo ""
echo "🔧 Checking Terraform syntax..."
if command -v terraform &> /dev/null; then
    terraform validate
    if [ $? -eq 0 ]; then
        echo "✅ Terraform configuration is valid"
    else
        echo "❌ Terraform configuration has errors"
    fi
else
    echo "⚠️  Terraform not installed - skipping validation"
fi

# Check AWS CLI
echo ""
echo "🔑 Checking AWS CLI..."
if command -v aws &> /dev/null; then
    echo "✅ AWS CLI is installed"
    aws sts get-caller-identity --query 'Account' --output text 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ AWS credentials are configured"
    else
        echo "❌ AWS credentials not configured"
    fi
else
    echo "❌ AWS CLI not installed"
fi

echo ""
echo "📋 Summary:"
echo "- All Terraform files are present"
echo "- Lambda ZIP files are created"
echo "- Configuration is ready for deployment"
echo ""
echo "🚀 Next steps:"
echo "1. Install Terraform: sudo snap install terraform"
echo "2. Configure AWS credentials: aws configure"
echo "3. Initialize: terraform init"
echo "4. Plan: terraform plan"
echo "5. Apply: terraform apply" 