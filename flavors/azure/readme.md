# Azure AKS Setup/Provisioning

## Prerequisites

Docker - https://docs.docker.com/get-docker/    

Azure Subscription: Your Microsoft subscription id (can retrieve after "az login")

Azure service principal: https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest

## Setting up tools

In order to provision a Kubernetes cluster using terraform you will need a few things installed notably the following:

    Terraform (v12), Azure Cli, Bash, Kubectl and Helm

As a way to get you quickly up and running, I have created a docker devops-cli image that incorporates and setups these tools for you so you can try provisioning the cluster without the hassle of setting up a bunch of tools locally.

To use the devops cli container execute the following in either powershell or in a linux shell:  

    docker run -it -v ${pwd}:/workspace ryanmcafee/devops-cli bash

You are now in the workspace directory and should be able to view all files and folders from the project root.

Run the following command:

    ls      

You should see all your files and folders. If you do not, ensure you have file and folder sharing enabled in Docker.

Next you will want to create an ssh key that will be used to allow you to connect to your Kubernetes cluster via ssh.       
You will need to set an ssh key in the default location of credentials/ssh/id_rsa.pub .
If you do not have an ssh key already generated, you can generate one with the command:     

    mkdir credentials/ssh -p && ssh-keygen -t rsa -b 2048 -f credentials/ssh/id_rsa -N ""

Now try running..

    terraform

Do you see a list of commands? You're good to go!

Some notable available commands are:

    az

    kubectl

    helm

    python  

### Initialize your terraform variables file (from provided example)

Sample terraform variable files are included with this repository. They include predefined defaults, however they do not include secrets or protected information. In team environments, you will likely be setting secrets and variables in a ci/cd system like Azure DevOps, Github Actions, CircleCi, Codefresh, Jenkins, etc. Terraform will use these files locally when you run the k8s provision script.

In order to start using the sample .tfvars files for Azure run the following commands from the root project directory:

    terraform workspace new azure

    cp flavors/azure/example.provider.tfvars customizations/workspaces/azure/provider.tfvars       

    cp flavors/azure/example.flavorize.tfvars customizations/workspaces/azure/flavorize.tfvars       

After doing so, you will want to set any variables in the .tfvars files that are expecting a replaced value.

In the directory: customizations/workspaces/azure...You will now notice 2 .tfvars files               

The first is provider.tfvars, this file tracks variable configuration that is specific to the provisioning requirements for a Kubernetes cluster on a given cloud provider.

The second is flavorize.tfvars, this file contains variables that are common across cloud providers and controls "flavorizing" your kubernetes cluster provisioning with common things like: ingress, externaldns, monitoring, alerting, etc. The variable is annotated to help you get started. Safe defaults are assumed to help you gradually opt into more kubernetes components as you find you need them. 

### Log into Azure (Via CLI)

```
az login
```    

Follow the instructions provided in the cli and then move on to the next section.     

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

After running the above, ensure you set "arm_tenant_id" and "arm_subscription_id" in customizations/workspaces/azure/provider.tfvars to the correct azure values you wish to use.

Now that you have set the tenant id and subscription id, the next step involves creating an Azure Service principal.

To create/setup a service principal for use with Terraform. Use [az ad sp create-for-rbac](https://docs.microsoft.com/en-us/cli/azure/ad/sp#az-ad-sp-create-for-rbac), and set the scope to your subscription as follows:

Powershell:
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${Get-ChildItem -Path Env:SUBSCRIPTION_ID}"
```

Bash
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
```

After running the above, ensure you set "arm_client_id" and "arm_client_secret" in customizations/workspaces/azure/provider.tfvars to the values obtained from creating the Azure Service Principal.
You are required to set these variables to the correct values in customizations/workspaces/azure/provider.tfvars in order for the Kubernetes provisioning to successfully complete via Terraform.

You will want to also review and set values in: customizations/workspaces/azure/flavorize.tfvars that work best for your workflow.

### Provisioning

Now that you have the boring stuff out the way, let's provision a Kubernetes cluster!

Run the command:

    ./provision.sh -flavor azure

The provision script will utilize terraform to provision a Kubernetes cluster along with some Kubernetes components if you have them configured in customizations/workspaces/azure/flavorize.tfvars. The provision script will also output the kube_config in the untracked credentials folder. The kubeconfig file will grant you access to the Kubernetes cluster and allow you to run additional commands by utilizing kubectl. Make sure to keep the kube_config safe at all times!

The provisioning script will auto merge your kubeconfig files if you already have one.      

If you are running the provisioning from inside a container, your kubeconfig will need to be set on your host os in order to use kubectl from your host os, vscode, etc.

You can set it on your host os as follows:      

Powershell:     

    $kube_config_dir = (([System.Environment]::GetEnvironmentVariable('USERPROFILE'))+"\.kube")
    New-Item -ItemType Directory -Path $kube_config_dir -Force
    Copy-Item -Path credentials/kubeconfig -Destination "${kube_config_dir}\config"
    [System.Environment]::SetEnvironmentVariable('KUBECONFIG', "${kube_config_dir}\config")

Bash:   

    mkdir -p ~/.kube
    cp credentials/kubeconfig ~/.kube/config
    export KUBECONFIG=~/.kube/config
    
If the provisioning was successful, you should be able to run the following command that will output running pods in the cluster:

    kubectl get pods --all-namespaces

Note: In order to communicate with the Kubernetes cluster from editors/tools like vscode, you will want to set the KUBECONFIG environment variable to the location of this file on the host system.

If you continue to experience issues please open an issue with details of the issue and we'll help you get it resolved. 

# Destroying/ Tearing Down Cluster

Run the following command:      

    ./destroy.ps1 -flavor azure