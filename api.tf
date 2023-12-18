

resource "aws_apigatewayv2_api" "robotdreams_api_gw" {
  name          = "robotdreams_api_gw"
  protocol_type = "HTTP"
#  disable_execute_api_endpoint = true
}

output "api_gw_endpoint" {
  value = aws_apigatewayv2_api.robotdreams_api_gw.api_endpoint
}

resource "aws_apigatewayv2_integration" "create_api_integration" {
  api_id                 = aws_apigatewayv2_api.robotdreams_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.create.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "create_api_route" {
  api_id    = aws_apigatewayv2_api.robotdreams_api_gw.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.create_api_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_integration" "read_api_integration" {
  api_id                 = aws_apigatewayv2_api.robotdreams_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.read.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "read_all_api_route" {
  api_id    = aws_apigatewayv2_api.robotdreams_api_gw.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.read_api_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "read_item_api_route" {
  api_id    = aws_apigatewayv2_api.robotdreams_api_gw.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.read_api_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_integration" "update_api_integration" {
  api_id                 = aws_apigatewayv2_api.robotdreams_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.update.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "update_api_route" {
  api_id    = aws_apigatewayv2_api.robotdreams_api_gw.id
  route_key = "PUT /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.update_api_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_integration" "delete_api_integration" {
  api_id                 = aws_apigatewayv2_api.robotdreams_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.delete.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "delete_api_route" {
  api_id    = aws_apigatewayv2_api.robotdreams_api_gw.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_api_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_stage" "crud_api_deploy_stage" {
  api_id      = aws_apigatewayv2_api.robotdreams_api_gw.id
  auto_deploy = true
  name        = "$default"
}
