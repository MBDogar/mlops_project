#!/bin/bash
set -e

echo ">>> Activating Minikube Docker"
eval $(minikube -p minikube docker-env)

cd ~/mlops_project

echo ">>> Pulling latest code"
git pull origin main

echo ">>> Building image with --no-cache"
docker build --no-cache -t height-app:latest .

echo ">>> Loading image into Minikube"
minikube image load height-app:latest

echo ">>> Confirming image is inside Minikube"
minikube ssh -- docker images | grep height-app

kubectl delete deployment height-app --ignore-not-found

echo ">>> Applying Kubernetes configs"
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo ">>> Restarting deployment"
kubectl rollout restart deployment height-app

echo ">>> Verifying deployment"
kubectl get pods -o wide
