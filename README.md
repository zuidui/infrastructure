# infraestru# Infraestructure As Code - IaC

in this repository, we work with infrastructure as code on a kubernetes cluster on AWS, we use two methods: terraform and cloudformation.

_Terraform_ is a standard language to work with infrastructure as code and standardize everything, although we will use our own modules to interact with AWS.

_CloudFormation_ on the other hand is proprietary to AWS and allows us to build infrastructure by applying different stacks within AWS.


## Configure AWS Credentials

- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

Generate Security Credentials using AWS Management Console
Go to Services -> IAM -> Users -> "Your-Admin-User" -> Security Credentials -> Create Access Key
Configure AWS credentials using SSH Terminal on your local desktop

# Configure AWS Credentials in command line
```sh
aws configure
```
AWS Access Key ID:  ...

AWS Secret Access Key: ...

Default region name: us-east-1

Default output format: json

```sh
# Working with different account on aws cli
aws configure --profile jg1938112
```
Los archivos deberían verse algo así:

~/.aws/config:     
  
[profile cuenta1]    
region = us-west-2 
[profile cuenta2]   
region = us-east-1 

~/.aws/credentials:

[cuenta1]
aws_access_key_id = <clave_de_acceso_1>
aws_secret_access_key = <clave_secreta_1>
[cuenta2]
aws_access_key_id = <clave_de_acceso_2>
aws_secret_access_key = <clave_secreta_2>

test: aws s3 ls --profile jg1938112


```sh
aws --version
```

# for example, verify if we are able list S3 buckets 
```sh
aws s3 ls
```
Verify the AWS Credentials Profile
```sh
cat ~/.aws/credentials
```