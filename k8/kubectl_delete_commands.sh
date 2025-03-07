#!/bin/bash

# Delete service
kubectl delete -f service.yaml

# Delete deployment
kubectl delete -f deployment.yaml

# Delete namespace
kubectl delete -f namespace.yaml