#!/bin/bash

# Apply namespace
kubectl apply -f namespace.yaml

# Apply deployment
kubectl apply -f deployment.yaml

# Apply service
kubectl apply -f service.yaml