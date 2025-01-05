# IAM Policy
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_role_name}-policy"
  description = "Policy for Lambda function with SQS, SNS, and CloudWatch Logs access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Permisos de CloudWatch Logs
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      
      # Permisos de SQS
      {
        Effect   = "Allow"
        Action   = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility",
          "sqs:GetQueueUrl",
          "sqs:SendMessage",              
          "sqs:PurgeQueue",               
          "sqs:ListQueues"               
        ]
        Resource = var.sqs_queue_arn
      },
      
      # Permisos de SNS
      {
        Effect   = "Allow"
        Action   = [
          "sns:Publish",
          "sns:Subscribe",               
          "sns:Unsubscribe",             
          "sns:ListSubscriptions",       
          "sns:ListTopics"              
        ]
        Resource = var.sns_topic_arn
      }
    ]
  })
}

# IAM Role
resource "aws_iam_role" "lambda_role" {
  name               = var.lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn

  depends_on = [
    aws_iam_role.lambda_role,
    aws_iam_policy.lambda_policy
  ]
}
