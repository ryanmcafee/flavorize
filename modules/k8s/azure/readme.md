# Azure AKS Setup/Provisioning

## Prerequisites

Docker - https://docs.docker.com/get-docker/    

Azure Subscription: Your Microsoft subscription id (can retrieve after "az login")

Azure service principal: https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest

## Setting up tools

In order to provision a kubernetes cluster using terraform you will need a few things installed notably the following:

    Terraform (v12), Azure Cli, Bash, and Kubectl

As a way to get you quickly up and running, I have created a docker devops-cli image that incorporates and setups these tools for you so you can try provisioning the cluster without the hassle of setting up a bunch of tools locally.

To use the devops cli container do the following:  

    Configure the folder mapping in docker-compose.yml to refer to your user profile directory + ./kube

    Next, in a shell run the following:     

        docker-compose run cli bash   

This will run a bash shell.

Now run:

    cd workspace

You are now in your home directory and viewing files and folders from your host computer.       

Now try running..

    terraform

Do you see a list of commands? You're good to go!

Available commands are: 

    az

    kubectl

    helm

    python

### Log into Azure (Via CLI)

```
az login
```

### Setup an Azure Service Principal

To enable Terraform to provision resources into Azure, create an [Azure AD service principal](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli). The service principal grants your Terraform scripts to provision resources in your Azure subscription.

If you have multiple Azure subscriptions, first query your account with [az account list](https://docs.microsoft.com/en-us/cli/azure/account#az-account-list) to get a list of subscription ID and tenant ID values:

```
az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}"
```

Depending on the Azure account you logged into the Azure CLI with, you may have access to multiple subscriptions. Please ensure that you use the correct Azure Subscription Id.

Set the SUBSCRIPTION_ID environment variable to hold the value of the returned id field from the subscription you want to use:

Powershell:
```
Set-Item -Path Env:SUBSCRIPTION_ID -Value 'xxxx-xxxx-xxxx-xxxx'
```

Bash:
```
export SUBSCRIPTION_ID='xxxx-xxxx-xxxx-xxxx'
```

To use a selected subscription, set the subscription for this session with [az account set](https://docs.microsoft.com/en-us/cli/azure/account#az-account-set)    

Powershell:
```
az account set --subscription="${Get-ChildItem -Path Env:SUBSCRIPTION_ID}"
```

Bash
```
az account set --subscription="${SUBSCRIPTION_ID}"
```

Now you can create a service principal for use with Terraform. Use [az ad sp create-for-rbac](https://docs.microsoft.com/en-us/cli/azure/ad/sp#az-ad-sp-create-for-rbac), and set the scope to your subscription as follows:

Powershell:
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${Get-ChildItem -Path Env:SUBSCRIPTION_ID}"
```

Bash
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
```

### Set up your terraform variables file

A sample terraform variable is included with this repository. It includes predefined defaults, however does not include include secrets or protected information. This information should not be tracked, you can safely keep track of secrets by storing variables locally in terraform.tfvars. Terraform will use this file locally when you run it and attempt to provision your Kubernetes cluster.

In order to start using the sample terraform.tfvars file run the following command:

    cp examples/terraform.tfvars.example.azure terraform.tfvars

After doing so, you will want to set any variables in the terraform.tfvars file that is expecting a replaced value (notably the arm_ variables).

### Provisioning

Run the command:

    ./provision.sh

If it was successful, you should be able to run:

    kubectl get pods --all-namespaces

If the provisioning completes successfully, however if you are unable to connect to your Kubernetes cluster using Kubectl you will want to verify the Kubernetes context being used and the location of the kubeconfig path.

You can do both as follows:     

    kubectl config view