

resource "aws_lambda_function" "create" {
  function_name = "robotdreams_lambda_create"

  s3_bucket = var.s3_bucket_name
  s3_key    = "v1.0.0/create.zip"

  handler = "create-function.lambda_handler"
  runtime = "python3.10"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "read" {
  function_name = "robotdreams_lambda_read"

  s3_bucket = var.s3_bucket_name
  s3_key    = "v1.0.0/read.zip"

  handler = "read-function.lambda_handler"
  runtime = "python3.10"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "update" {
  function_name = "robotdreams_lambda_update"

  s3_bucket = var.s3_bucket_name
  s3_key    = "v1.0.0/update.zip"

  handler = "update-function.lambda_handler"
  runtime = "python3.10"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "delete" {
  function_name = "robotdreams_lambda_delete"

  s3_bucket = var.s3_bucket_name
  s3_key    = "v1.0.0/delete.zip"

  handler = "delete-function.lambda_handler"
  runtime = "python3.10"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "crud-api-exec-role-policy"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "dynamodb:*",
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "logs:CreateLogGroup",
                "Resource": "arn:aws:logs:us-east-1:839399074955:*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": [
                    "arn:aws:logs:us-east-1:839399074955:log-group:/aws/lambda/*:*"
                ]
            },
            {
                "Action": [
                    "s3:Get*"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::bucket-for-arhived-lambdas-12-12-23",
                    "arn:aws:s3:::bucket-for-arhived-lambdas-12-12-23/*",
                ]
            }
        ]
  })
}

resource "aws_iam_role" "lambda_exec" {
  name = "crud-api-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_lambda_permission" "apigw_create" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.robotdreams_api_gw.execution_arn}/*/POST/items"
}

resource "aws_lambda_permission" "apigw_read_all" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.robotdreams_api_gw.execution_arn}/*/GET/items"
}

resource "aws_lambda_permission" "apigw_read_item" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.robotdreams_api_gw.execution_arn}/*/GET/items/{id}"
}

resource "aws_lambda_permission" "apigw_update" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.robotdreams_api_gw.execution_arn}/*/PUT/items/{id}"
}

resource "aws_lambda_permission" "apigw_delete" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.robotdreams_api_gw.execution_arn}/*/DELETE/items/{id}"
}