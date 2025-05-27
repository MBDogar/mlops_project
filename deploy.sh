#!/bin/bash
set -e

echo "📁 Switching to project directory..."
cd ~/mlops_project || { echo "❌ Project directory not found!"; exit 1; }

echo "🧼 Cleaning up dangling images..."
docker image prune -f

echo "🔥 Deleting old Docker image if it exists..."
docker rmi height-app:latest || echo "🟡 No previous image to remove."

echo "🌀 Switching to Minikube Docker environment..."
eval $(minikube -p minikube docker-env)

echo "🧠 Verifying Docker is using Minikube..."
docker info | grep -i 'Docker Root Dir' || { echo "❌ Not using Minikube Docker daemon!"; exit 1; }

echo "🔍 Checking for Dockerfile..."
test -f Dockerfile || { echo "❌ Dockerfile not found in $(pwd)"; exit 1; }

echo "🏗️ Training the model..."
python3 train.py

echo "🔍 Verifying model.joblib exists..."
test -f model.joblib || { echo "❌ model.joblib not found after training!"; exit 1; }

echo "📦 Building Docker image..."
docker build -t height-app:latest .

echo "📸 Verifying Docker image built:"
docker images | grep height-app || { echo "❌ Image height-app not built!"; exit 1; }

echo "🆔 Capturing built Image ID..."
BUILT_IMAGE_ID=$(docker images height-app:latest -q)
echo "✅ Built Image ID: $BUILT_IMAGE_ID"

echo "📤 Loading image into Minikube..."
minikube image load height-app:latest

echo "🔍 Verifying image in Minikube Docker..."
minikube ssh -- docker images | grep height-app

echo "🗑️ Deleting existing deployment (if any)..."
kubectl delete deployment height-app --ignore-not-found

echo "📝 Applying Kubernetes deployment and service manifests..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "🔁 Restarting deployment to use new image..."
kubectl rollout restart deployment height-app

echo "⏳ Waiting for pod to be ready..."
kubectl rollout status deployment/height-app

echo "🔍 Getting pod info to confirm image used..."
POD_NAME=$(kubectl get pods --selector=app=height-app -o jsonpath="{.items[0].metadata.name}")
CONTAINER_IMAGE_ID=$(kubectl get pod $POD_NAME -o jsonpath="{.status.containerStatuses[0].imageID}")

echo "✅ Pod is using image ID: $CONTAINER_IMAGE_ID"
echo "✅ Local built image ID: docker://$BUILT_IMAGE_ID"

if [[ "$CONTAINER_IMAGE_ID" == *"$BUILT_IMAGE_ID" ]]; then
  echo "✅ SUCCESS: Pod is using the correct image!"
else
  echo "❌ ERROR: Pod is not using the newly built image!"
fi

echo "🎉 Done!"
