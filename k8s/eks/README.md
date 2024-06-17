# Infraestructure EKS

## Deployment

Run docker:

```sh
sudo service docker start
```

Execute minikube:

```sh
minikube start
```

Enable the ingress addon first to access the client app:

```sh
minikube addons enable ingress
```

Apply all the infrastructure resources and wait until everything is up:

```sh
kubectl apply -f utils/
kubectl apply -f configMaps/
kubectl apply -f ingress/
kubectl apply -f volumes/
kubectl apply -f services/resources
kubectl apply -f services/
```

To view al resources in the cluster in real time:

```sh
watch -n 1 kubectl get pods,services,deployments
```

or:

```sh
minikube dashboard
```

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
