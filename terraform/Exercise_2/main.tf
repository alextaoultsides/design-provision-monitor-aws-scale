provider "aws" {
  access_key = "youraccesskey"
  secret_key = "yoursercretkey"
  region = var.aws_region
}

resource "aws_iam_role" "lambda_exec" {
   name = "lambda_role"

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/greet_lambda"
  retention_in_days = 14
}

resource "aws_lambda_function" "udacity_lambda_P2" {
  filename = "lambda.zip"
  function_name = "udacity_lambda_p2"
  handler = "greet_lambda.lambda_handler"
  role = "${aws_iam_role.lambda_exec.arn}"
  runtime = "python3.8"
  source_code_hash = "${base64sha256(filebase64("lambda.zip"))}"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
}

