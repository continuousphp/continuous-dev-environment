# continuous-dev-environment

## Goal

This repository could help you to deploy easily your development environment

##### Install Python

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
```

##### Install npm

```bash
curl -O https://npmjs.org/install.sh
sudo sh install.sh
```

##### Install AWS CLI

```bash
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
```

## installation

### preparation :

prepare your hosted zone in Route 53.
Create you certificate for your base domain
(you can add a wildcard subdomain) : https://aws.amazon.com/fr/certificate-manager/

Deploy manually the `init.yml` stack in order to have `cloudformation` user that you will use to deploy the local environement, and the `cloudformation-cloud9-role` used by cloudformation service during the deployment.

### update local environment

replace variables in Makefile with your info:

```
bucket=example-template-bucket
role=arn:aws:iam::ACCOUNTID:role/cloudformation-role
certificateArn=arn:aws:acm:us-east-1:ACCOUNTID:certificate/CERTIFICATEID
baseDomain=example.com
certificateArn=arn:aws:acm:us-east-1:ACCOUNTID:certificate/CERTIFICATEID
roleSSO=continuous-team-sso-Role-ABCDEFG
```

Additionaly you can specify AWS Credentials profile and Region.

```
region=us-east-1
profile=myprofile
```

### run it

```bash
make package
make deploy
```

### finalize

To finalize the configuration connect to AWS console.  
Go to EC2/LoadBlancing/targetGroup and add your instance to a new target group.

### Launch

In your AWS Console, search for cloud9 service and enjoy.

## deletion

```bash
make delete
```
