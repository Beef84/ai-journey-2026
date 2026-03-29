# Lambda function, its IAM role, and a Function URL for streaming responses.
# The Function URL replaces API Gateway — invoke_mode RESPONSE_STREAM enables
# true SSE streaming through CloudFront without response buffering.

resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.prefix}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow"
        Action   = ["bedrock:InvokeAgent"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "api" {
  function_name = "${var.prefix}-api"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  timeout       = 30

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  # AGENT_ALIAS_ID is a placeholder; CI overwrites it with the real alias ID
  # via aws lambda update-function-configuration after alias creation.
  environment {
    variables = {
      AGENT_ID        = var.agent_id
      AGENT_ALIAS_ID  = ""
      GATEWAY_SECRET  = var.gateway_secret
    }
  }
}

# Function URL with streaming enabled. auth_type = NONE because CloudFront
# handles access control via the x-cloudfront-secret header checked in Lambda.
resource "aws_lambda_function_url" "api" {
  function_name      = aws_lambda_function.api.function_name
  authorization_type = "NONE"
  invoke_mode        = "RESPONSE_STREAM"
}
