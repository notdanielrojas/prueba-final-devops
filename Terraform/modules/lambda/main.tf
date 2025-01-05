resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = var.lambda_role_arn
  filename      = archive_file.lambda_function_zip.output_path
   environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}


resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = var.sqs_queue_arn
  function_name = aws_lambda_function.lambda_function.function_name
  batch_size       = var.lambda_batch_size
  enabled          = var.lambda_trigger_enabled
}

resource "aws_lambda_permission" "allow_sqs_invoke" {
  statement_id  = "AllowSQSToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = var.sqs_queue_arn
}

resource "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_dir  = var.lambda_source_path
  output_path = "${path.module}/lambda_function.zip"
}