resource "aws_sns_topic" "sns_prueba_final" {
  name = var.topic_name
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn = aws_sns_topic.sns_prueba_final.arn
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.sns_prueba_final.arn}",
      "Principal": "*"
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sns_prueba_final.arn
  protocol  = "email"
  endpoint  = var.email_address
}

