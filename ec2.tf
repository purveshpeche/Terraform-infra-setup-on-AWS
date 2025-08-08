# EC2 Instances for MigrationAI

# Key Pair for EC2 instances
resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVjToQ+S/guPaXJu8oj5E9J0aFVangNEApiqlCS1tf9X0zUw0/D+rI1ykFnfsckM6yxYeM56/GRN6NGqSzl8EqEuvzLRuh22845WO65Jk70BrsQWtvJhVJRobMNf5S+wGckmlKvx4gn+Wq6GtJMvzEWznH2pAVF1qQWFrzlTqzJwYj56GD6jZ60g2fQK9LNYqhX0dR0Q9Rkn6M2F5NvtgIMn7f/G" # Placeholder key - replace with your actual public key

  tags = {
    Name = "${var.project_name}-${var.environment}-key"
  }
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  }
}

# IAM Policy for EC2 instances (ECR access, Systems Manager, CloudWatch)
resource "aws_iam_role_policy" "ec2_policy" {
  name = "${var.project_name}-${var.environment}-ec2-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssm:SendCommand",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations",
          "ssm:DescribeInstanceInformation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.main.arn,
          "${aws_s3_bucket.main.arn}/*"
        ]
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}



# Data source for latest Ubuntu 22.04 LTS AMI in us-west-2
data "aws_ami" "ubuntu_22_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# EC2 Instance for Backend
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = "t3a.large"
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.backend.id]
  subnet_id              = aws_subnet.private[0].id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = 153
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update system
              apt-get update -y
              
              # Install Docker
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ubuntu
              
              # Install AWS Systems Manager agent
              mkdir -p /tmp/ssm
              cd /tmp/ssm
              wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
              dpkg -i amazon-ssm-agent.deb
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              
              # Install CloudWatch agent
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
              dpkg -i amazon-cloudwatch-agent.deb
              systemctl enable amazon-cloudwatch-agent
              
              # Configure CloudWatch agent
              cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json << 'CONFIG'
              {
                "agent": {
                  "metrics_collection_interval": 60,
                  "run_as_user": "cwagent"
                },
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/syslog",
                          "log_group_name": "/aws/ec2/migrationai-backend",
                          "log_stream_name": "{instance_id}",
                          "timezone": "UTC"
                        },
                        {
                          "file_path": "/var/log/docker.log",
                          "log_group_name": "/aws/ec2/migrationai-backend/docker",
                          "log_stream_name": "{instance_id}",
                          "timezone": "UTC"
                        }
                      ]
                    }
                  }
                },
                "metrics": {
                  "metrics_collected": {
                    "disk": {
                      "measurement": ["used_percent"],
                      "metrics_collection_interval": 60,
                      "resources": ["*"]
                    },
                    "mem": {
                      "measurement": ["mem_used_percent"],
                      "metrics_collection_interval": 60
                    }
                  }
                }
              }
              CONFIG
              
              # Start CloudWatch agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
              systemctl start amazon-cloudwatch-agent
              
              # Clean up
              rm -rf /tmp/ssm
              
              # Install AWS CodeDeploy Agent
              apt-get install -y ruby-full wget
              cd /home/ubuntu
              wget https://aws-codedeploy-${var.aws_region}.s3.${var.aws_region}.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              systemctl enable codedeploy-agent
              systemctl start codedeploy-agent
              
              # Verify CodeDeploy agent installation
              systemctl status codedeploy-agent
              EOF

  tags = {
    Name = "migrationai-backend"
  }
}

# EC2 Instance for TFP
resource "aws_instance" "tfp" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = "t3a.large"
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.backend.id]
  subnet_id              = aws_subnet.private[1].id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = 153
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update system
              apt-get update -y
              
              # Install Docker
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ubuntu
              
              # Install AWS Systems Manager agent
              mkdir -p /tmp/ssm
              cd /tmp/ssm
              wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
              dpkg -i amazon-ssm-agent.deb
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              
              # Install CloudWatch agent
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
              dpkg -i amazon-cloudwatch-agent.deb
              systemctl enable amazon-cloudwatch-agent
              
              # Configure CloudWatch agent
              cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json << 'CONFIG'
              {
                "agent": {
                  "metrics_collection_interval": 60,
                  "run_as_user": "cwagent"
                },
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/syslog",
                          "log_group_name": "/aws/ec2/migrationai-tfp",
                          "log_stream_name": "{instance_id}",
                          "timezone": "UTC"
                        },
                        {
                          "file_path": "/var/log/docker.log",
                          "log_group_name": "/aws/ec2/migrationai-tfp/docker",
                          "log_stream_name": "{instance_id}",
                          "timezone": "UTC"
                        }
                      ]
                    }
                  }
                },
                "metrics": {
                  "metrics_collected": {
                    "disk": {
                      "measurement": ["used_percent"],
                      "metrics_collection_interval": 60,
                      "resources": ["*"]
                    },
                    "mem": {
                      "measurement": ["mem_used_percent"],
                      "metrics_collection_interval": 60
                    }
                  }
                }
              }
              CONFIG
              
              # Start CloudWatch agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
              systemctl start amazon-cloudwatch-agent
              
              # Clean up
              rm -rf /tmp/ssm
              
              # Install AWS CodeDeploy Agent
              apt-get install -y ruby-full wget
              cd /home/ubuntu
              wget https://aws-codedeploy-${var.aws_region}.s3.${var.aws_region}.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              systemctl enable codedeploy-agent
              systemctl start codedeploy-agent
              
              # Verify CodeDeploy agent installation
              systemctl status codedeploy-agent
              EOF

  tags = {
    Name = "migrationai-tfp"
  }
} 

# CloudWatch Log Groups for EC2 instances
resource "aws_cloudwatch_log_group" "ec2_backend" {
  name              = "/aws/ec2/migrationai-backend"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-backend-logs"
  }
}

resource "aws_cloudwatch_log_group" "ec2_backend_docker" {
  name              = "/aws/ec2/migrationai-backend/docker"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-backend-docker-logs"
  }
}

resource "aws_cloudwatch_log_group" "ec2_tfp" {
  name              = "/aws/ec2/migrationai-tfp"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-tfp-logs"
  }
}

resource "aws_cloudwatch_log_group" "ec2_tfp_docker" {
  name              = "/aws/ec2/migrationai-tfp/docker"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-tfp-docker-logs"
  }
} 