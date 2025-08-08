# SQS Queues for MigrationAI Workers

# Dead Letter Queues (DLQs) - Created FIRST
resource "aws_sqs_queue" "dlq_contacts" {
  name = "dlq-prod-migrationai-contacts"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-contacts"
  }
}

resource "aws_sqs_queue" "dlq_projects" {
  name = "dlq-prod-migrationai-projects"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-projects"
  }
}

resource "aws_sqs_queue" "dlq_sections" {
  name = "dlq-prod-migrationai-sections"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-sections"
  }
}

resource "aws_sqs_queue" "dlq_notes" {
  name = "dlq-prod-migrationai-notes"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-notes"
  }
}

resource "aws_sqs_queue" "dlq_calendar" {
  name = "dlq-prod-migrationai-calendar"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-calendar"
  }
}

resource "aws_sqs_queue" "dlq_tasks" {
  name = "dlq-prod-migrationai-tasks"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-tasks"
  }
}

resource "aws_sqs_queue" "dlq_billing_items" {
  name = "dlq-prod-migrationai-billing-items"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-billing-items"
  }
}

resource "aws_sqs_queue" "dlq_project_funds" {
  name = "dlq-prod-migrationai-project-funds"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-project-funds"
  }
}

resource "aws_sqs_queue" "dlq_billing_invoice" {
  name = "dlq-prod-migrationai-billing-invoice"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-billing-invoice"
  }
}

resource "aws_sqs_queue" "dlq_payment" {
  name = "dlq-prod-migrationai-payment"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-payment"
  }
}

resource "aws_sqs_queue" "dlq_project_email" {
  name = "dlq-prod-migrationai-project-email"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-project-email"
  }
}

resource "aws_sqs_queue" "dlq_document" {
  name = "dlq-prod-migrationai-document"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-document"
  }
}

resource "aws_sqs_queue" "dlq_jobs" {
  name = "dlq-prod-migrationai-jobs"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "dlq-prod-migrationai-jobs"
  }
}

# Standard Queues - Created AFTER DLQs
resource "aws_sqs_queue" "contacts" {
  name = "prod-migrationai-contacts"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_contacts.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-contacts"
  }
}

resource "aws_sqs_queue" "projects" {
  name = "prod-migrationai-projects"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_projects.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-projects"
  }
}

resource "aws_sqs_queue" "sections" {
  name = "prod-migrationai-sections"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_sections.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-sections"
  }
}

resource "aws_sqs_queue" "notes" {
  name = "prod-migrationai-notes"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_notes.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-notes"
  }
}

resource "aws_sqs_queue" "calendar" {
  name = "prod-migrationai-calendar"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_calendar.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-calendar"
  }
}

resource "aws_sqs_queue" "tasks" {
  name = "prod-migrationai-tasks"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_tasks.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-tasks"
  }
}

resource "aws_sqs_queue" "billing_items" {
  name = "prod-migrationai-billing-items"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_billing_items.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-billing-items"
  }
}

resource "aws_sqs_queue" "project_funds" {
  name = "prod-migrationai-project-funds"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_project_funds.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-project-funds"
  }
}

resource "aws_sqs_queue" "billing_invoice" {
  name = "prod-migrationai-billing-invoice"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_billing_invoice.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-billing-invoice"
  }
}

resource "aws_sqs_queue" "payment" {
  name = "prod-migrationai-payment"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_payment.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-payment"
  }
}

resource "aws_sqs_queue" "project_email" {
  name = "prod-migrationai-project-email"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_project_email.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-project-email"
  }
}

resource "aws_sqs_queue" "document" {
  name = "prod-migrationai-document"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_document.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-document"
  }
}

resource "aws_sqs_queue" "jobs" {
  name = "prod-migrationai-jobs"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  max_message_size           = 262144

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_jobs.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "prod-migrationai-jobs"
  }
} 