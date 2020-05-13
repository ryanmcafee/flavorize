# Azure AKS Setup/Provisioning

## Prerequisites

Docker - https://docs.docker.com/get-docker/    

Azure Subscription: Your Microsoft subscription id (can retrieve after "az login")

Azure service principal: https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest

## Setting up tools

In order to provision a kubernetes cluster using terraform you will need a few things installed notably the following:

    Terraform (v12), Azure Cli, Bash, Kubectl and Helm

As a way to get you quickly up and running, I have created a docker devops-cli image that incorporates and setups these tools for you so you can try provisioning the cluster without the hassle of setting up a bunch of tools locally.

To use the devops cli container execute the following in either powershell or in a linux shell:  

    docker run -it --rm -v ${pwd}:/workspace ryanmcafee/devops-cli bash

You are now in the workspace directory and should be able to view all files and folders from the project root.

Run the following command:

    ls      

You should see all your files and folders. If you do not, ensure you have file and folder sharing enabled in Docker.     

Now try running..

    terraform

Do you see a list of commands? You're good to go!

Some notable available commands are:

    az

    kubectl

    helm

    python

### Log into Azure (Via CLI)

```
az login
```    

Follow the instructions provided in the cli and then move on to the next section.       

### Initialize your terraform variables file (from provided example)

After logging into Azure, you will want to initialize and setup your terraform variables file.

A sample terraform variable for interacting with Azure is included with this repository. It includes predefined defaults, however does not include include secrets or protected information. This information should not be tracked, you can safely keep track of secrets by storing variables locally in terraform.tfvars. Terraform will use this file locally when you run it and attempt to provision your Kubernetes cluster.

In order to start with the sample terraform.tfvars file for Microsoft Azure run the following command from the root project directory:     

    cp examples/terraform.tfvars.example.azure terraform.tfvars

After doing so, you will want to set any variables in the terraform.tfvars file that is expecting a replaced value (notably arm_subscription_id, arm_client_id & arm_client_secret). You will see how to set these variables in the subsequent sections.

### Setup an Azure Service Principal & Setting Values in Terraform Variables File

To enable Terraform to provision resources into Azure, create an [Azure AD service principal](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli). The service principal grants your Terraform scripts permission/ the ability to provision resources in your Azure subscription.

If you have multiple Azure subscriptions, first query your account with [az account list](https://docs.microsoft.com/en-us/cli/azure/account#az-account-list) to get a list of subscription ID and tenant ID values:

```
az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}"
```

Depending on the Azure account you logged into the Azure CLI with, you may have access to multiple subscriptions. Please ensure that you choose/use the correct Azure Subscription Id.

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

Bash
```
az account set --subscription="${SUBSCRIPTION_ID}"
```

Powershell:
```
az account set --subscription="${Get-ChildItem -Path Env:SUBSCRIPTION_ID}"
```

Now that is completed you will need to set "arm_subscription_id" in terraform.tfvars to the value obtained from above. Make sure you set "arm_subscription_id" to the same value of the SUBSCRIPTION_ID environment variable you set above.

Now that you have set the subscription id, the next step involves creating an Azure Service principal.

To create/setup a service principal for use with Terraform. Use [az ad sp create-for-rbac](https://docs.microsoft.com/en-us/cli/azure/ad/sp#az-ad-sp-create-for-rbac), and set the scope to your subscription as follows:

Powershell:
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${Get-ChildItem -Path Env:SUBSCRIPTION_ID}"
```

Bash
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
```

After running the above, ensure you set "arm_client_id" and "arm_client_secret" in terraform.tfvars to the values obtained from creating the Azure Service Principal.
You are required to set these variables to the correct values in terraform.tfvars in order for the kubernetes provisioning to successfully complete via terraform.

### Provisioning

Now that you have the boring stuff out the way, let's provision a kubernetes cluster!

Run the command:

    ./provision.sh

The provision shell script will utilize terraform to provision a Kubernetes cluster along with some kubernetes components if you have them configured in terraform.tfvars. The provision script will also output the kube_config in the untracked credentials folder and sets the KUBECONFIG environment variable to the location of this file. The kubeconfig file will grant you access to kubernetes cluster and allow you to run additional commands by utilizing kubectl. Make sure to keep the kube_config safe at all times!  

If the provisioning was successful, you should be able to run the following command that will output running pods in the cluster:

    kubectl get pods --all-namespaces

Note: In order to communicate with the Kubernetes cluster from editors/tools like vscode, you will want to set the KUBECONFIG environment variable to the location of this file on the host system.

Note: If the provisioning does not work and you have gone through the above steps, check that you only have one k8s module uncommented in main.tf that matches Azure.     

If you continue to experience issues please open an issue with details of the issue and we'll help you get it resolved. 