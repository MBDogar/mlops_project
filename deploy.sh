#!/bin/bash
set -e

echo ">>> Changing to project directory"
cd ~/mlops_project

echo ">>> Pulling latest code"
git pull origin main

echo ">>> Using Minikube Docker daemon"
eval $(minikube -p minikube docker-env)

echo ">>> Building Docker image (no cache)"
docker build --no-cache -t height-app:latest .

echo ">>> Loading image into Minikube"
minikube image load height-app:latest

kubectl delete deployment height-app --ignore-not-found

echo ">>> Applying Kubernetes manifests"
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo ">>> Restarting deployment"
kubectl rollout restart deployment height-app

echo ">>> Done"
