# create cluster
```sh
eksctl create cluster --name development --dry-run
```
Last command return a basic yaml file
# crear cluster y nodos
```sh
eksctl create cluster -f cluster_EKS.yml
AWS_PROFILE=jg1938112 eksctl create cluster -f cluster_EKS.yml
```
Inside CloudFormation module can see the stack with all steps, in this case we find two stack: cluster and nodes(ec2)

![alt text](/documents/cloudformation.png "cloudformation")

-binding kubectl with cluster:
```sh
aws eks --region us-east-1 update-kubeconfig --name jgl-cluster
AWS_PROFILE=jg1938112 aws eks --region us-east-1 update-kubeconfig --name jgl-clusterkubectl
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




+++++++++
Problemas encontrados:
failed to create: [ManagedNodeGroup]
You've reached your quota for maximum Fleet Requests for this account. Launching EC2 instance failed.
+++++++++