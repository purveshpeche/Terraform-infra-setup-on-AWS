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

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# IAM Policy for EC2 instances
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
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [
          aws_sqs_queue.contacts.arn,
          aws_sqs_queue.projects.arn,
          aws_sqs_queue.sections.arn,
          aws_sqs_queue.notes.arn,
          aws_sqs_queue.calendar.arn,
          aws_sqs_queue.tasks.arn,
          aws_sqs_queue.billing_items.arn,
          aws_sqs_queue.project_funds.arn,
          aws_sqs_queue.billing_invoice.arn,
          aws_sqs_queue.payment.arn,
          aws_sqs_queue.project_email.arn,
          aws_sqs_queue.document.arn,
          aws_sqs_queue.jobs.arn
        ]
      }
    ]
  })
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
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ubuntu
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
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ubuntu
              EOF

  tags = {
    Name = "migrationai-tfp"
  }
} 