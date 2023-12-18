

resource "aws_cognito_user_pool" "pool" {
  name = "robotdreams_cognito_user_pool"
}


resource "aws_cognito_user_pool_client" "client" {
  name = "robotdreams_cognito_user_pool_client"
  user_pool_id = aws_cognito_user_pool.pool.id
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

resource "aws_cognito_user" "example" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username = "robotdreams_default_user"
  password = "pasS123@_sds23"
}

resource "aws_apigatewayv2_authorizer" "auth" {
  api_id           = aws_apigatewayv2_api.robotdreams_api_gw.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.client.id]
    issuer   = "https://${aws_cognito_user_pool.pool.endpoint}"
  }
}

output "aws_cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.client.id
}
