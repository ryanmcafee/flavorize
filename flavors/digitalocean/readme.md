# Digital Ocean K8s Provisioning

## Prerequisites

[Digital Ocean Account](https://m.do.co/c/da921ed87c7d)     

[Digital Ocean Api Token](https://cloud.digitalocean.com/account/api/tokens)       

[Docker](https://docs.docker.com/get-docker/)       

## Setting up tools

In order to provision a kubernetes cluster using terraform on Digital Ocean you will need a few things installed notably the following:

Terraform (v12)     
Digital Ocean Cli       
Bash        
Kubectl     
Helm     

As a way to get you quickly up and running, I have created a docker devops-cli image that incorporates and setups these tools for you so you can try provisioning the cluster without the hassle of setting up a bunch of tools locally.

To use the devops cli container execute the following in either powershell or in a linux shell:  

    docker run -it -v ${pwd}:/workspace ryanmcafee/devops-cli bash

You are now in the workspace directory and should be able to view all files and folders from the project root.

Run the following command:

ls      

You should see all your files and folders. If you do not, ensure you have file and folder sharing enabled in Docker.       

Now try running..

    terraform

Do you see a list of commands? You're good to go!

Some notable available commands are: 

    doctl

    kubectl

    helm

    python

### Set up your terraform variables file

Sample terraform variable files are included with this repository. They include predefined defaults, however they do not include secrets or protected information. In team environments, you will likely be setting secrets and variables in a ci/cd system like Azure DevOps, Github Actions, CircleCi, Codefresh, Jenkins, etc. Terraform will use these files locally when you run the k8s provision script.

In order to start using the sample terraform.tfvars file for Digital Ocean run the following commands from the root project directory:

    terraform workspace new digitalocean

    cp flavors/digitalocean/example.provider.tfvars customizations/workspaces/digitalocean/provider.tfvars       

    cp flavors/digitalocean/example.flavorize.tfvars customizations/workspaces/digitalocean/flavorize.tfvars             

After doing so, you will want to set any variables in the terraform.tfvars file that is expecting a replaced value (notably the do_token).

You will now notice 2 .tfvars files under customizations....               

The first is provider.tfvars, this file tracks variable configuration that is specific to the provisioning requirements for a Kubernetes cluster on a given cloud provider.

The second is flavorize.tfvars, this file contains variables that are common across cloud providers and controls "flavorizing" your kubernetes cluster provisioning with common things like: ingress, externaldns, monitoring, alerting, etc. The variable is annotated to help you get started. Safe defaults are assumed to help you gradually opt into more kubernetes components as you find you need them.        

### Log into Digital Ocean (Via CLI) & Update Variables

```
doctl auth init
```

You will be asked to enter your DigitalOcean access token. You can generate a token in the control panel at https://cloud.digitalocean.com/account/api/tokens. 
Copy and paste the token in and press enter.  
This will set the auth token so you will be able to utilize the digital ocean cli tool to retrieve available options you can set and control in provider.tfvars

Now that you know your Digital Ocean Api token, you will need to set the value in customizations/workspaces/digitalocean/provider.tfvars.  

Your changes in customizations/workspaces/digitalocean/provider.tfvars and customizations/workspaces/digitalocean/flavorize.tfvars are not tracked in git by default (see .gitignore).  

These variable files are intentionally not tracked to allow for easier consumption and contributions to this library.   

For a production system, it is recommended to configure and store variables' values and secrets in your ci/cd system.    

### Available Variables

For Cloud Provider Specific Variables...     
See [Digital Ocean Variables](flavors/digitalocean/example.provider.tfvars)        

For common variables for provisioning things like: ingress, externaldns, monitoring, alerting, etc...      
See [Common Variables](flavors/digitalocean/example.flavorize.tfvars)        

### Provisioning

Confirm that you have set the variables correctly before running the following command to setup the cluster.

Run the command:     

    ./provision.ps1 -flavor digitalocean

Take a break, this should take between 5-10 minutes.    

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

Note: If the provisioning does not work and you have gone through the above steps, check that your variables are correctly set and all software dependencies have been met.

If you continue to experience issues please open an issue with details of the issue and we'll help you get it resolved.     

# Destroying/ Tearing Down Cluster

Run the following command:      

    ./destroy.ps1 -flavor digitalocean