# Usage Guide

This document explains how to run the `oan-ui-service` using Docker and Kubernetes.

## 1. Running with Docker

First, pull the image from Docker Hub (make sure to replace `[YOUR_DOCKER_USERNAME]` with your actual Docker Hub username if pulling a published image, or just use your local image name if built locally):

```bash
docker pull [YOUR_DOCKER_USERNAME]/oan-ui-service:latest
```

### Basic Run
To run the container on port `8081` with the default settings:

```bash
docker run -d -p 8081:8081 --name oan-ui [YOUR_DOCKER_USERNAME]/oan-ui-service:latest
```

### Running with Environment Variables (with Telemetry)
The Docker image is designed to accept environment variables dynamically at runtime. You can pass them using the `-e` flag. Here is a comprehensive example showing how to configure telemetry along with other variables:

```bash
docker run -d \
  -p 8081:8081 \
  --name oan-ui \
  -e VITE_API_URL="https://api.my-production-server.com" \
  -e VITE_APP_TITLE="OAN Custom Web App" \
  -e VITE_DEFAULT_LANGUAGE="en" \
  -e VITE_JWT_AUDIENCE="your-keycloak-client-uuid" \
  -e VITE_JWT_ISSUER="https://your-keycloak-server.com/realms/your-realm" \
  -e VITE_JWT_EXPIRY_DAYS="7" \
  -e VITE_BYPASS_AUTH="true" \
  -e VITE_ENABLE_TELEMETRY="true" \
  -e VITE_TELEMETRY_HOST="https://telemetry.your-domain.com" \
  -e VITE_TELEMETRY_KEY="your-telemetry-api-key" \
  -e VITE_TELEMETRY_SECRET="your-telemetry-secret" \
  -e VITE_TELEMETRY_CHANNEL="oan-web-channel" \
  -e VITE_TELEMETRY_PRODUCT_ID="oan-ui" \
  [YOUR_DOCKER_USERNAME]/oan-ui-service:latest
```

You can view the `Dockerfile` for a complete list of all supported `VITE_*` environment variables and what they do.

---

## 2. Deploying with Kubernetes (`kubectl`)

You can deploy the application using a standard Kubernetes Deployment and Service. Save the following YAML snippet into a file named `oan-ui-deployment.yaml`. Notice how telemetry secrets are being exposed dynamically.

### `oan-ui-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: oan-ui-deployment
  labels:
    app: oan-ui
spec:
  replicas: 2
  selector:
    matchLabels:
      app: oan-ui
  template:
    metadata:
      labels:
        app: oan-ui
    spec:
      containers:
      - name: oan-ui-container
        image: [YOUR_DOCKER_USERNAME]/oan-ui-service:latest # Remember to update the image name!
        ports:
        - containerPort: 8081
        env:
        # Core App Config
        - name: VITE_API_URL
          value: "https://api.my-production-server.com"
        - name: VITE_APP_TITLE
          value: "OAN production system"
          
        # Enable Telemetry
        - name: VITE_ENABLE_TELEMETRY
          value: "true"
        
        # Pulling Telemetry URL from a ConfigMap
        - name: VITE_TELEMETRY_HOST
          valueFrom:
            configMapKeyRef:
              name: oan-ui-config
              key: TELEMETRY_HOST
              
        # Telemetry identifiers
        - name: VITE_TELEMETRY_CHANNEL
          value: "oan-k8s-channel"
        - name: VITE_TELEMETRY_PRODUCT_ID
          value: "oan-ui"
          
        # Pulling Telemetry Key/Secret securely from a Kubernetes Secret
        - name: VITE_TELEMETRY_KEY
          valueFrom:
            secretKeyRef:
              name: oan-ui-secrets
              key: TELEMETRY_KEY
        - name: VITE_TELEMETRY_SECRET
          valueFrom:
            secretKeyRef:
              name: oan-ui-secrets
              key: TELEMETRY_SECRET
---
apiVersion: v1
kind: Service
metadata:
  name: oan-ui-service
spec:
  type: ClusterIP # Change to NodePort or LoadBalancer if you need external access
  selector:
    app: oan-ui
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8081
```

### Apply the Deployment

Apply the configuration file using `kubectl`:

```bash
kubectl apply -f oan-ui-deployment.yaml
```

Verify everything is running:

```bash
# Check the pods
kubectl get pods -l app=oan-ui

# Check the service
kubectl get svc oan-ui-service
```
