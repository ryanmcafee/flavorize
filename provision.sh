#!/usr/bin/env bash

#Initialize terraform
terraform init

#Create the terraform plan
terraform plan -out out.plan

#Apply the terraform plan
terraform apply out.plan

#Get the kube_config output from the terraform state and extract into local file
echo "$(terraform output kube_config)" > $USERPROFILE/.kube/config

#Set the kubeconfig context so we'll be able to talk to the k8s api
export KUBECONFIG=$USERPROFILE/.kube/config

