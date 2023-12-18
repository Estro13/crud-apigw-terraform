



data "aws_acm_certificate" "api" {
  domain = "*.autosearch.company"
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = "robotdreams.autosearch.company"

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.api.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

output "aws_apigatewayv2_domain_name" {
  value = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
}


resource "aws_apigatewayv2_api_mapping" "api_v1" {
  api_id      = aws_apigatewayv2_api.robotdreams_api_gw.id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = aws_apigatewayv2_stage.crud_api_deploy_stage.id
  api_mapping_key = "v1"
}

resource "aws_apigatewayv2_api_mapping" "api_v2" {
  api_id          = aws_apigatewayv2_api.robotdreams_api_gw.id
  domain_name     = aws_apigatewayv2_domain_name.api.id
  stage           = aws_apigatewayv2_stage.crud_api_deploy_stage.id
  api_mapping_key = "v2"
}

output "custom_domain_api_v1" {
  value = "https://${aws_apigatewayv2_api_mapping.api_v1.domain_name}/${aws_apigatewayv2_api_mapping.api_v1.api_mapping_key}"
}

output "custom_domain_api_v2" {
  value = "https://${aws_apigatewayv2_api_mapping.api_v2.domain_name}/${aws_apigatewayv2_api_mapping.api_v2.api_mapping_key}"
}