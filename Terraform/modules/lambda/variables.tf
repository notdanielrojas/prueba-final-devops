variable "lambda_name" {
  description = "Lambda function name"
  type        = string
}

variable "lambda_handler" {
  description = "The Lambda function handler"
  type        = string
}

variable "lambda_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "The IAM role ARN for the Lambda function"
  type        = string
}

variable "lambda_filename" {
  type        = string
  description = "The filename of the Lambda zip file."
  default     = "./modules/lambda/src/lambda_function.zip"
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue that triggers the Lambda function"
  type        = string
}

variable "lambda_batch_size" {
  description = "The batch size for the Lambda trigger"
  type        = number
  default     = 10
}

variable "lambda_trigger_enabled" {
  description = "Enable or disable the Lambda trigger"
  type        = bool
  default     = true
}

variable "lambda_source_path" {
  description = "The source directory for the Lambda function code"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN del tema SNS"
  type        = string
}