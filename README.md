# Provision Kubernetes With Terraform

This repo is used for provisioning Kubernetes clusters declaratively using Terraform.  
Terraform is great for provisioning infrastructure across multiple providers (both on premise and cloud).  
Got a problem with your cluster? Just destroy it and bring it back up.  

Obviously, you'll want to think twice before destroying your Kubernetes cluster in production (stateful data sets, etc..),  
but when setting up your Kubernetes cluster or upgrading some of it's components (ingress controller, certmanager, externaldns, etc..) it is a great tool to use and can really help.

Kubernetes is complex and vendors often incorporate their own offerings and encourage you to use their "cloud" and "apis".
In the short term, directly utilizing cloud providers' cli sdks directly to provision kubernetes clusters seems like the way to go.
I would encourage you to not do that. Using Terraform makes setup and provisioning repeatable and reliable allowing others to reuse your infrastructure blueprint. It can also make cross cloud infrastructure deployments more easily achievable.

Currently, Azure is the only provider that this repo currently handles provisioning for, however you can add support for other providers as well. I designed the implementation to be modular and flexible to support additional cloud providers. I also plan on adding Digital Ocean support shortly. PR requests are welcome and much appreciated!

The terraform configuration for provisioning Kubernetes will vary slightly according to the cloud provider, so please consult your cloud provider's documentation.

# Contributing

## Adding Kubernetes Cluster Provisioning Support For Additional Cloud/On Premise Provider

In order to add support for an additional cloud provider you'll want to do the following:

1) Add your new Terraform cloud provider resource plugin to providers.tf and make sure that you set the correct version number for it to work reliably for others.

2) Create additional directory under modules/k8s/{cloudProviderName} and place 3 files there: k8s.tf, variables.tf and output.tf

3) Consult documentation for your cloud provider that you are adding support for and update k8s.tf in your directory accordingly. Please also ensure that the provider's resources will only attempt provisioning when the value for your cloud_provider is set to your new provider. You can accomplish this by using a ternary statement and the count property. Look at the azure provider for an example of this.

4) Ensure that the available output variables conform to the same output variables used in: modules/k8s/azure/output.tf so we can continue to interchangably provision common resources across cloud providers (certmanager, ingress controller, externaldns, etc..).

5) Add any additional provider specific variables to: modules/k8s/{cloudProviderName}/variables.tf.

6) Add your new provider to main.tf in the directory root with the same module name of "k8s". After doing so and testing it out to make sure it works, please comment out the additional provider. To my knowledge, Terraform currently doesn't offer a way to disable a module at the module level, so for now this is the best work around I can think of. Please open an issue, if you have a better recommendation.

7) Lastly, ensure that any additional variables specific to your provider have been added to terraform.tfvars.example

8) Test your change again

9) Create a pull request

## Adding Support For Additional Cluster Component (ExternalDNS Provider, Ingress Provider, etc..)

In order to add support for an additional kubernetes cluster components, do the following:

1) Create additional directory under modules/components/{componentType}/{componentImplementation} and place at least 3 files there: main.tf and variables.tf.

2) Consult documentation for your kubernetes component you are adding support for. Would recommend reviewing available published Helm charts as a starting point. Please also ensure that the provider's resources will only attempt provisioning when the value for your your provider is selected by the end user's config. You can accomplish this by using a ternary statement and the count property. Look at the certmanager/cloudflare example for this.

3) Add/ wire up your new module to main.tf (in the directory root) with a module name of {componentType}-{componentImplementation}.

4) Lastly, ensure that any additional variables specific to your provider have been added to terraform.tfvars.example

5) Test your change again

6) Create a pull request

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

    cp terraform.tfvars.example terraform.tfvars

After doing so, you will want to set any variables in the terraform.tfvars file that is expecting a replaced value (notably the arm_ variables).

### Provisioning

Run the command:

    ./provision.sh

If it was successful, you should be able to run:

    kubectl get pods --all-namespaces

If the provisioning completes successfully, however if you are unable to connect to your Kubernetes cluster using Kubectl you will want to verify the Kubernetes context being used and the location of the kubeconfig path.

You can do both as follows:     

    kubectl config view