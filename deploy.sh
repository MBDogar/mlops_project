#!/bin/bash
set -e

echo "=============================="
echo " [0/6] Setting up environment"
echo "=============================="

# Load shell environment
source ~/.bashrc || true
source ~/.profile || true

# Point Docker to Minikube's Docker daemon
eval $(minikube -p minikube docker-env)

# Set Kubernetes context
kubectl config use-context minikube

# Check Docker environment
echo ">> Docker Environment:"
env | grep DOCKER || echo "No Docker env vars — may not be using Minikube Docker."

# Check Docker info
echo ">> Docker Info:"
docker info | grep -E 'Server Version|Docker Root Dir'

# Check Minikube info
echo ">> Minikube Info:"
minikube ip
minikube profile list

echo
echo "=============================="
echo " [1/6] Change to project directory"
echo "=============================="
cd /home/murtazabilalqasim/mlops_project

echo
echo "=============================="
echo " [2/6] Pull latest code"
echo "=============================="
git pull origin main

echo
echo "=============================="
echo " [3/6] Build Docker image with tag height-app:latest"
echo "=============================="
docker build -t height-app:latest .

echo
echo "=============================="
echo " [4/6] Load image into Minikube"
echo "=============================="
minikube image load height-app:latest

echo ">> Confirm image exists in Minikube:"
minikube ssh -- docker images | grep height-app

echo
echo "=============================="
echo " [5/6] Apply Kubernetes configs"
echo "=============================="

# Ensure imagePullPolicy is Never in deployment.yaml
if ! grep -q "imagePullPolicy: Never" k8s/deployment.yaml; then
  echo "⚠️  imagePullPolicy not set to Never — patching it..."
  sed -i 's|imagePullPolicy:.*|imagePullPolicy: Never|' k8s/deployment.yaml || true
fi

kubectl delete deployment height-app --ignore-not-found

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo
echo "=============================="
echo " [6/6] Restart deployment and show status"
echo "=============================="
kubectl rollout restart deployment height-app
kubectl get pods -o wide

echo
echo "✅ Deployment completed using image height-app:latest"