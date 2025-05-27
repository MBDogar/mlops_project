#!/bin/bash
set -e

echo "=============================="
echo " [0/7] Setting up environment"
echo "=============================="

# Load user's shell profile (in case minikube is added via .bashrc)
source ~/.bashrc || true
source ~/.profile || true

# Point Docker to Minikube's Docker daemon
eval $(minikube -p minikube docker-env)

# Set Kubernetes context to Minikube
kubectl config use-context minikube

# Print Docker environment variables
echo
echo ">> DOCKER ENVIRONMENT VARIABLES:"
env | grep DOCKER || echo "No DOCKER env vars found. You may not be using Minikube's Docker!"

# Print Docker engine info
echo
echo ">> DOCKER INFO:"
docker info | grep -E 'Name:|Server Version|Docker Root Dir'

# Print Minikube IP and profiles
echo
echo ">> MINIKUBE INFO:"
minikube ip
minikube profile list

# Unique tag for debug
IMAGE_TAG="height-app:debug-$(date +%s)"

echo
echo "=============================="
echo " [1/7] Changing to project directory"
echo "=============================="
cd /home/murtazabilalqasim/mlops_project

echo
echo "=============================="
echo " [2/7] Pulling latest code"
echo "=============================="
git pull origin main

echo
echo "=============================="
echo " [3/7] Building Docker image (no cache) with tag $IMAGE_TAG"
echo "=============================="
docker build --no-cache -t $IMAGE_TAG .

echo
echo "=============================="
echo " [4/7] Loading image into Minikube"
echo "=============================="
minikube image load $IMAGE_TAG

echo
echo ">> Confirming image is in Minikube:"
minikube ssh -- docker images | grep height-app

echo
echo "=============================="
echo " [5/7] Updating Kubernetes deployment"
echo "=============================="
# Update deployment YAML to use the new tag (temp)
sed "s|image: height-app:latest|image: $IMAGE_TAG|" k8s/deployment.yaml > k8s/deployment-debug.yaml

kubectl apply -f k8s/deployment-debug.yaml
kubectl apply -f k8s/service.yaml

echo
echo "=============================="
echo " [6/7] Restarting Deployment"
echo "=============================="
kubectl rollout restart deployment height-app

echo
echo "=============================="
echo " [7/7] Final Pod Status"
echo "=============================="
kubectl get pods -o wide

echo
echo "✅ Deployment completed with image tag: $IMAGE_TAG"