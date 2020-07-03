GREEN = \033[0;32m
YELLOW = \x1b[33m
NC = \033[0m

default:help;

include environments/config.mvars

appName=continuous-dev-environment
region=us-east-1
stack_name=$(appName)
profile=default

EC2InstanceId=$(shell aws ec2 describe-instances --profile $(profile) --region $(region) --filters "Name=instance-type,Values=m5.large" --query "Reservations[*].Instances[*].{Instance:InstanceId}"  --output text)
WebappTargetGroup=$(shell aws cloudformation describe-stacks --profile $(profile) --stack-name $(appName) --region $(region) --query "Stacks[0].Outputs[?OutputKey=='WebappTargetGroup'].OutputValue" --output text)
ApiTargetGroup=$(shell aws cloudformation describe-stacks --profile $(profile)  --stack-name $(appName) --region $(region) --query "Stacks[0].Outputs[?OutputKey=='ApiTargetGroup'].OutputValue" --output text)

## Display this help dialog
help:
	@echo "${YELLOW}Usage:${NC}\n  make [command]:\n\n${YELLOW}Available commands:${NC}"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${GREEN}%-30s${NC} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Update aws-cli
cphp-update-aws-cli:
	pip install awscli --upgrade --user

## Package Cloud Formation template
package:
	  aws --profile $(profile) \
		--region $(region) \
	  cloudformation package \
		--template-file template.yml \
		--s3-bucket $(bucket) \
		--output-template-file template-output.yml

## Deploy Cloud Formation stack
deploy:
	aws --profile $(profile) \
		--region $(region) \
	  cloudformation deploy \
		--template-file template-output.yml \
		--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
		--role-arn $(role) \
		--stack-name $(stack_name) \
		--parameter-overrides BaseDomain=$(baseDomain) CertificateArn=$(certificateArn) \
		User=$(user) RoleSSO=$(roleSSO)


## Describe Cloud Formation stack outputs
describe:
	@aws --profile $(profile) \
		--region $(region) \
	  cloudformation describe-stacks \
		--stack-name $(stack_name) \
		--query 'Stacks[0].Outputs[*].[OutputKey, OutputValue]' --output text

## Delete Cloud Formation stack
delete:
	aws --profile $(profile) \
		--region $(region) \
	  cloudformation delete-stack \
		--stack-name $(stack_name)

target-group:
	aws elbv2 register-targets --target-group-arn $(WebappTargetGroup) --targets Id=$(EC2InstanceId) --region $(region) --profile $(profile)
	aws elbv2 register-targets --target-group-arn $(ApiTargetGroup) --targets Id=$(EC2InstanceId) --region $(region) --profile $(profile)
