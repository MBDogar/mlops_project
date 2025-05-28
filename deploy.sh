#!/bin/bash
set -e

cd ~/mlops_project

echo "📦 Training model..."
python3 train.py

# Enable Minikube Docker daemon
echo "🔁 Switching to Minikube Docker daemon..."
eval $(minikube -p minikube docker-env)

# Use unique image tag
TAG="height-app:build-$(date +%s)"
echo "🏗️ Building image: $TAG"
docker build -t $TAG .

# Load image into Minikube
echo "📤 Loading image into Minikube..."
minikube image load $TAG

# Apply manifests (if not already present)
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Update deployment with new image
echo "🛠️ Updating Kubernetes deployment with image $TAG"
kubectl set image deployment/height-app height-app=$TAG --record

kubectl rollout restart deployment height-app

echo "⏳ Waiting for rollout to finish..."
kubectl rollout status deployment/height-app

echo "✅ Done! New image: $TAG"
