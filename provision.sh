#!/usr/bin/env bash

#Initialize terraform
terraform init

#Create the terraform plan
terraform plan -out out.plan

#Apply the terraform plan
terraform apply out.plan

# Cleanup
rm build -fr

# Get what cloud_provider was used
export cloud_provider="$(terraform output cloud_provider)"

# Create directory to store k8s credentials
mkdir -p credentials/${cloud_provider}/.kube

# Extract out the kube_config file for usage later
echo "$(terraform output kube_config)" > credentials/${cloud_provider}/.kube/config

# Set the kubeconfig context so we'll be able to talk to the k8s api via kubectl
export KUBECONFIG=credentials/${cloud_provider}/.kube/config
