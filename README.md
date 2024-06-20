# Infraestructure

![GitHub](https://img.shields.io/github/license/zuidui/api-gateway)

## Overview

In this repository, we work with infrastructure as code on a kubernetes cluster on AWS, we use two methods: terraform and cloudformation and everything related to kubernetes deployment, helm and continuous deployment.

### Infraestructure As Code - IaC :rocket:
_Terraform_ is a standard language to work with infrastructure as code and standardize everything, although we will use our own modules to interact with AWS.

_CloudFormation_ on the other hand is proprietary to AWS and allows us to build infrastructure by applying different stacks within AWS.

# Configure AWS cli

## Configure AWS Credentials

- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

Generate Security Credentials using AWS Management Console
Go to Services -> IAM -> Users -> "Your-Admin-User" -> Security Credentials -> Create Access Key
Configure AWS credentials using SSH Terminal on your local desktop

## Configure AWS Credentials in command line
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
the files should look like the following:

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

## for example, verify if we are able list S3 buckets 
```sh
aws s3 ls
```
Verify the AWS Credentials Profile
```sh
cat ~/.aws/credentials
```

# EKS - cloudFormation

## create cluster
```sh
eksctl create cluster --name development --dry-run
```
Last command return a basic yaml file
## crear cluster y nodos
```sh
eksctl create cluster -f cluster_EKS.yml
AWS_PROFILE=jg1938112 eksctl create cluster -f cluster_EKS.yml
```
Inside CloudFormation module can see the stack with all steps, in this case we find two stack: cluster and nodes(ec2)
-binding kubectl with cluster:
```sh
aws eks --region us-east-1 update-kubeconfig --name jgl-cluster
AWS_PROFILE=jg1938112 aws eks --region us-east-1 update-kubeconfig --name jgl-cluster
```

--------------------------------------------------------
# Create manually cluster
-Create cluster EKS with the specific configuration
-create two roles on IAM:
    -(EKS-cluster):AmazonEKSClusterPolicy
    -(EC2):AmazonEKS_CNI_Policy,AmazonEKSWorkerNodePolicy,AmazonEC2ContainerRegistryReadOnly
- create workerNodes
    -compute->add node group , choose the type of instances etc
    
-binding kubectl with cluster:
```sh
aws eks --region eu-central-1 update-kubeconfig --name nombreCluster
```
-modify ec2->security-groups and edit inbound groups, create rules to our port where server the service 

# EKS - terraform
architecture as code with terraform to AWS services 

```sh
terraform fmt      # format everu files .tf

terraform login    # yes and enter pass, to up a repository in terraform registry

terraform init     # download all dependencies and modules 

terraform validate

terraform plan     #show deploy plan with all resources 

terraform apply -auto-approve # deploy in cloud provider

# Terraform Destroy
terraform apply -destroy -auto-approve
rm -rf .terraform*
rm -rf terraform.tfstate*

aws eks update-kubeconfig --region us-west-1 --name jgl-eks --alias jgl-eks --profile default
```
# Infraestructure Local

## Deployment

Run docker:

```sh
sudo service docker start # in a linux SO is not mandatory
```

Prepare cluster minikube:

```sh
make start # Provision a cluster with all resources
```

Deploy application complete:

```sh
make deploy_app
```

To view al resources in the cluster in real time:

```sh
watch -n 1 kubectl get pods,services,deployments
```

or:

```sh
minikube dashboard
```
or:

Use Lens app

## Associate domain name to IP to get access

```sh
echo "`minikube ip` tfm-local" | sudo tee --append /etc/hosts >/dev/null
```

## Verification

The app will be accesible in [http://tfm-local](http://tfm-local).

Any HTTP request will be handled properly. For example:

```sh
curl --location --request GET 'http://tfm-local/api/v1/users
```

# nginx ingress on EKS

deploy ingress controller
```sh
make enable_ingress_EKS
```

# ArgoCD Image Updater
```sh
make install_argocd # if the cluster havent ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443 #expose argocd app in localhost port 8080
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo #Return the pass
argocd login localhost:8080
#if we want update the pass, fist login in Argo with the last command, afterwards update the pass with the following command.
#the pass must have a lengh between 8 and 32 characteres
argocd account update-password
```
To Access ArgoCD application:

http://localhost:8080

Enter user and pass:

user: admin
pass: get with following command

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
## Create the application on ArgoCD
```sh
#from path /api-gateway/CRD/
kubectl apply -f CRD.yml #this is a type of resource in kubernetes to deploy application.
```





# ArgoCD Rollout
```sh
#install argo rollout in cluster
make install_argocd_rollout
```

Steps(api-gateway service example):

From path: zuidui/api-gateway/chart:

1. use chart api-gateway-rollout
    we replace deployment.yml to rollout.yml(it is same but add the deploymnet strategy)
3. helm package api-gateway-rollout 
2. helm install api-gateway-rollout ./api-gateway-rollout
4. change the image tag
5. generate pkg again -> helm package api-gateway-rollout 
6. helm upgrade api-gateway-rollout  ./api-gateway-rollout-0.1.0.tgz

check deployment
```sh
# Get the deployment strategy in a specify namespace
kubectl argo rollouts get rollout api-gateway-rollout  -n zuidui
kubectl argo rollouts dashboard
# Access to argo release interface
http://localhost:3100
```