# AWSLambdaNodejs
1. First setup role:
Source file in IAM folder

2. Setup credentials:
Windows like: C:\\Users\\your name\\.aws\\Credentials
Ubuntu like:/home/Jenkins/.aws/Credentials

3. Run terraform init, plan and apply in AWSLambdaNodejs

Resources:
Terraform IAM role
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy

AWS Policy generate
https://awspolicygen.s3.us-east-1.amazonaws.com/policygen.html

AWS API Gateway function
https://registry.terraform.io/providers/hashicorp%20%20/aws/latest/docs/resources/api_gateway_integration

AWS Lambda function
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

Jenkins docker:
https://github.com/berndonline/jenkins-docker
