resource "aws_iam_role" "lambda_exec_role" {
name = "cloudops-lambda-exec-role"

assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Action = "sts:AssumeRole"
Effect = "Allow"
Principal = {
Service = "lambda.amazonaws.com"
}
}
]
})
}

resource "aws_iam_role_policy" "lambda_policy" {
name = "cloudops-lambda-policy"
role = aws_iam_role.lambda_exec_role.id

policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Effect = "Allow"
Action = [
"logs:CreateLogGroup",
"logs:CreateLogStream",
"logs:PutLogEvents"
]
Resource = "*"
},
{
Effect = "Allow"
Action = [
"dynamodb:PutItem",
"dynamodb:Scan"
]
Resource = aws_dynamodb_table.app_table.arn
}
]
})
}

resource "aws_lambda_function" "api_function" {
function_name = "cloudops-api-function"
role = aws_iam_role.lambda_exec_role.arn
handler = "app.lambda_handler"
runtime = "python3.12"
filename = "${path.module}/lambda/function.zip"
source_code_hash = filebase64sha256("${path.module}/lambda/function.zip")
timeout = 10

environment {
variables = {
TABLE_NAME = aws_dynamodb_table.app_table.name
}
}
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
name = "/aws/lambda/cloudops-api-function"
retention_in_days = 7
}

resource "aws_apigatewayv2_api" "http_api" {
name = "cloudops-http-api"
protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
api_id = aws_apigatewayv2_api.http_api.id
integration_type = "AWS_PROXY"
integration_uri = aws_lambda_function.api_function.invoke_arn
integration_method = "POST"
payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "health_route" {
api_id = aws_apigatewayv2_api.http_api.id
route_key = "GET /health"
target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "create_item_route" {
api_id = aws_apigatewayv2_api.http_api.id
route_key = "POST /items"
target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "list_items_route" {
api_id = aws_apigatewayv2_api.http_api.id
route_key = "GET /items"
target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
api_id = aws_apigatewayv2_api.http_api.id
name = "$default"
auto_deploy = true
}

resource "aws_lambda_permission" "allow_api_gateway" {
statement_id = "AllowExecutionFromAPIGateway"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.api_function.function_name
principal = "apigateway.amazonaws.com"
source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
