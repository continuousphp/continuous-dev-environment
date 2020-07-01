# continuous-dev-environment

## Goal

This repository could help you to deploy easily your development environment

## requirements

you must install :

 - python 3
 - pip - aws cli - aws credentials

## installation

### preparation :

prepare your hosted zone in Route 53.
Create you certificate for your base domain
(you can add a wildcard subdomain) : https://aws.amazon.com/fr/certificate-manager/

Deploy manually the `init.yml` stack in order to have `cloudformation` user that you will use to deploy the local environement, and the `cloudformation-cloud9-role` used by cloudformation service during the deployment.

### create local environment 

```bash
export env=dev
cp environments/dev.mvars.dist environments/dev.mvars
```

replace env vars :

```
bucket=example-template-bucket
role=arn:aws:iam::ACCOUNTID:role/cloudformation-role
certificateArn=arn:aws:acm:us-east-1:ACCOUNTID:certificate/CERTIFICATEID
baseDomain=example.com
certificateArn=arn:aws:acm:eu-west-1:ACCOUNTID:certificate/CERTIFICATEID roleSSO=continuous-team-sso-Role-ABCDEFG
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
