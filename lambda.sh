#!/bin/bash -xe

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
RUNTIME="provided.al2023"
FUNCTION_NAME="Function-With-SNS"
TOPIC_NAME="sns-topic-for-lambda"
IAM_ROLE="lambda-sbe-role"

# Create an SNS topic
#aws sns create-topic --region "${AWS_DEFAULT_REGION}" --name ${TOPIC_NAME} 

# TODO: Need to change these options for a golang based function

# For golang handlers in lambda, the handler name should be the name of the go binary you upload to lambda.
# go build -o mybinary main.go (IE: mybinary would be the handler from previous example)

aws lambda create-function --function-name ${FUNCTION_NAME} \
    --region "${AWS_DEFAULT_REGION}" \
    --zip-file fileb://snowball-lambda-marketplace/myFunction.zip --handler bootstrap --runtime ${RUNTIME} \
    --architectures x86_64 \
    --role arn:aws:iam::${AWS_ACCOUNT_ID}:role/${IAM_ROLE} \
    --timeout 60

# Grant SNS permission to invoke the lambda function
aws lambda add-permission --function-name ${FUNCTION_NAME} \
    --region "${AWS_DEFAULT_REGION}" \
    --source-arn "arn:aws:sns:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:${TOPIC_NAME}" \
    --statement-id function-with-sns --action "lambda:InvokeFunction" \
    --principal sns.amazonaws.com

aws sns subscribe --protocol lambda \
    --region "${AWS_DEFAULT_REGION}" \
    --topic-arn "arn:aws:sns:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:${TOPIC_NAME}" \
    --notification-endpoint "arn:aws:lambda:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:function:${FUNCTION_NAME}"

exit 0

aws sns publish --topic-arn "arn:aws:sns:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:${TOPIC_NAME}" \
    --region "${AWS_DEFAULT_REGION}" \
    --message "Test Message"

aws lambda invoke --function-name ${FUNCTION_NAME} out --log-type Tail \
    --region "${AWS_DEFAULT_REGION}" 
#    --query 'LogResult' --output text --cli-binary-format raw-in-base64-out | base64 --decode
