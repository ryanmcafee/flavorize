#!/usr/bin/env bash

#Initialize terraform
terraform init

plan="out.plan"

#Create the terraform plan
terraform plan -var-file=customizations/terraform.tfvars -var-file=customizations/terraform.common.tfvars -out $plan

#Apply the terraform plan
terraform apply $plan

# Cleanup
rm build -fr

# Get what cloud_provider was used
export cloud_provider="$(terraform output cloud_provider)"

# Create directory to store k8s credentials
mkdir -p credentials/${cloud_provider}/.kube

# Extract out the kube_config file for usage later
# Store the kube config file in shared (host) credentials folder in case we're running from a container.
echo "$(terraform output kube_config)" > credentials/${cloud_provider}/.kube/config

# Will persist kubeconfig to user's profile
echo "$(terraform output kube_config)" > ~/.kube/config

if [ -f $plan ] ; then
    rm $plan -f
fi
