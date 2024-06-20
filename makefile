# Variables
MINIKUBE_PROFILE := minikube-cluster

# MINIKUBE
start_cluster:
	minikube start --profile=$(MINIKUBE_PROFILE) 
	kubectl delete namespace zuidui

delete_cluster:
	minikube stop --profile=$(MINIKUBE_PROFILE)
	minikube delete --profile=$(MINIKUBE_PROFILE)
	@echo "Cluster deleted"

enable_ingress:
	minikube addons enable ingress --profile=$(MINIKUBE_PROFILE)

# Install ArgoCD
install_argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml 

# Install ArgoCD rollout
install_argocd_rollout:
	kubectl create namespace argo-rollouts
	kubectl apply -n argo-rollouts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml

# Delete ArgoCD
delete_argocd:
	kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml 
	kubectl delete namespace argocd
	@echo "Delete argocd namespace manually when objects are finalized"
# Delete ArgoCD rollout
install_argocd_rollout:
	kubectl delete -n argo-rollouts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml
	kubectl delete namespace argo-rollouts
	@echo "Delete argocd rollout namespace manually when objects are finalized"
deploy_app:
	kubectl apply -f k8s/minikube/utils/
	kubectl apply -f k8s/minikube/ingress/
	kubectl apply -f k8s/minikube/volumes/
	kubectl apply -f k8s/minikube/services/resources
	kubectl apply -f k8s/minikube/services/
#EKS
enable_ingress_EKS:
	kubectl create namespace ingress-nginx
	helm install my-nginx-controller ingress-nginx/ingress-nginx --namespace ingress-nginx
# Tareas
start: start_cluster enable_ingress install_argocd install_argocd_rollout

#deploy: build-image load-image deploy-app expose-app apply-ingress