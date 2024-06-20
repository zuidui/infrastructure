# terraform-EKS
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




********
Problemas encontrados:

-addons de cluster da error por deprecados --> comentados de momento, lo spuedo añadir a mano sino en EKS
-limite de recursos  de fleet o algo asialcanzado en una region --> cambiamos a otra region 
-KMS existente(este se puede programar borrado cada 7 dias) y group logs en cloudwatch existente(este se borra del tiron) --> le cambio nombre a cluster 
-module.eks.kubernetes_config_map_v1_data.aws_auth:  connection refused 
********