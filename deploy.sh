#!/bin/bash
set -e

echo ">>> Changing to project directory"
cd ~/mlops_project

echo ">>> Pulling latest code"
git pull origin main

echo "🐳 Using Minikube's Docker daemon"
eval $(minikube -p minikube docker-env)

echo "🧠 Training model"
python3 train.py

echo "🏷️ Generating unique image tag"
TAG="height-app:build-$(date +%s)"
echo "🧱 Building Docker image with tag $TAG"
docker build -t $TAG .

echo "📤 Loading image into Minikube"
minikube image load $TAG

echo "🛠️ Updating Kubernetes deployment to use image: $TAG"
kubectl set image deployment/height-app height-app=$TAG --record || {
    echo "⛔ Deployment not found, creating a new one..."
    kubectl apply -f k8s/deployment.yaml
    kubectl set image deployment/height-app height-app=$TAG --record
}

echo "✅ Deployment updated successfully"
