locals{
    lambda_zip_Location = "outputs/TestApi.zip"
}

data "archive_file" "TestApi" {
  type        = "zip"
  source_file = "index.js"
  output_path = "${local.lambda_zip_Location}"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "${local.lambda_zip_Location}"
  function_name = "TestApi"
  role          = var.lambda_role_arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256("outputs/TestApi.zip")

  runtime = "nodejs12.x"
}

resource "aws_api_gateway_rest_api" "simple_api" {
  name = "simple_api"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.simple_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.simple_api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.simple_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.simple_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  #source_arn = "${aws_apigatewayv2_api.TestApi2.execution_arn}/*/*/*"
  source_arn = "arn:aws:execute-api:us-east-2:${var.accountId}:${aws_api_gateway_rest_api.simple_api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}