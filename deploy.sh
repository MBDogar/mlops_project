#!/bin/bash
set -e

echo "=============================="
echo " [0/6] Setting up environment"
echo "=============================="

# Load user environment in case PATHs or Minikube are set there
source ~/.bashrc || true
source ~/.profile || true

# Set Docker to use Minikube's Docker daemon
eval $(minikube -p minikube docker-env)

# Use Minikube's kubectl context
kubectl config use-context minikube

# Confirm Docker context
echo
echo ">> Docker Info:"
docker info | grep -E 'Name:|Server Version|Storage Driver'

# Confirm current Minikube profile and IP
echo
echo ">> Minikube Info:"
minikube profile list
minikube ip

echo
echo "=============================="
echo " [1/6] Changing to project directory"
echo "=============================="
cd /home/murtazabilalqasim/mlops_project

echo
echo "=============================="
echo " [2/6] Pulling latest code"
echo "=============================="
git pull origin main

echo
echo "=============================="
echo " [3/6] Building Docker image (no cache)"
echo "=============================="
docker build --no-cache -t height-app:latest .

echo
echo "=============================="
echo " [4/6] Loading image into Minikube"
echo "=============================="
minikube image load height-app:latest

echo
echo "=============================="
echo " [5/6] Deploying to Kubernetes"
echo "=============================="
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo
echo ">> Restarting deployment"
kubectl rollout restart deployment height-app

echo
echo ">> Current pods:"
kubectl get pods -o wide

echo
echo "=============================="
echo " [6/6] Deployment complete"
echo "=============================="
