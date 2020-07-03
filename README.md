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

Please refer to official AWS <a href= https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html>docs</a>.

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

### after stack created

Add your instance to a new target group.
The `target-group` Makefile rule may not work correctly if multiple m5.large instances are present in the targeted region (another m5.large instance may be picked up). Execute this BEFORE the finalize step.
```bash
make target-group
```

### finalize

Manually change your cloud9 EC2 instance type to r5a.large.

### Launch

In your AWS Console, search for cloud9 service and enjoy.

## deletion

```bash
make delete
```
