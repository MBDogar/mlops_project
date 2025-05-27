#!/bin/bash
set -e

echo ">>> Changing to project directory"
cd ~/mlops_project

echo "deleting prone images"
docker image prune -f

echo "Deleting old Docker image (if exists)..."
docker rmi height-app:latest || echo "Image not found, continuing..."

echo ">>> Pulling latest code"
git pull origin main

echo ">>> Using Minikube Docker daemon"
eval $(minikube -p minikube docker-env)

echo "🔍 Checking for Dockerfile..."
test -f Dockerfile || { echo "❌ Dockerfile not found in $(pwd)"; exit 1; }

echo "🏗️ Running training script..."
python3 train.py

echo "🧪 Checking if model.joblib exists..."
test -f model.joblib || { echo "❌ model.joblib not found. train.py likely failed."; exit 1; }

echo "🔥 Removing previous image (if exists)..."
docker rmi height-app:latest || echo "No previous image to remove."

echo "📦 Building Docker image..."
docker build -t height-app:latest .

echo "✅ Checking image creation..."
docker images | grep height-app || { echo "❌ Image was not created."; exit 1; }

echo "📤 Loading image into Minikube..."
minikube image load height-app:latest

echo "🚀 Redeploying to Kubernetes..."
kubectl delete deployment height-app --ignore-not-found
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "✅ Deployment complete!"
kubectl delete deployment height-app --ignore-not-found

echo ">>> Applying Kubernetes manifests"
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo ">>> Restarting deployment"
kubectl rollout restart deployment height-app

echo ">>> Done"
