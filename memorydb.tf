# MemoryDB Redis Cluster for MigrationAI
resource "aws_memorydb_cluster" "redis" {
  acl_name             = "open-access"
  name                 = "migrationai-redis-cache"
  node_type            = "db.t4.micro"
  port                 = 6379
  parameter_group_name = "default.memorydb-redis6"
  subnet_group_name    = aws_memorydb_subnet_group.main.name
  security_group_ids   = [aws_security_group.redis.id]

  tags = {
    Name = "migrationai-redis-cache"
  }
}

# MemoryDB Subnet Group
resource "aws_memorydb_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-memorydb-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.project_name}-${var.environment}-memorydb-subnet-group"
  }
}

# Security Group for Redis
resource "aws_security_group" "redis" {
  name        = "${var.project_name}-${var.environment}-redis-sg"
  description = "Security group for MemoryDB Redis cluster"
  vpc_id      = aws_vpc.main.id

  # Allow Redis access from backend security group
  ingress {
    description     = "Redis"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-redis-sg"
  }
} 