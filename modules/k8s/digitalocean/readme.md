# Digital Ocean K8s Provisioning

## Prerequisites

Docker - https://docs.docker.com/get-docker/    

Digital Ocean Api Token Subscription    

You can generate a token in the control panel at https://cloud.digitalocean.com/account/api/tokens

## Setting up tools

In order to provision a kubernetes cluster using terraform you will need a few things installed notably the following:

    Terraform (v12), Digital Ocean Cli, Bash, and Kubectl

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

    doctl

    kubectl

    helm

    python

### Log into Digital Oceanm (Via CLI)

```
doctl auth init
```

### Set up your terraform variables file

A sample terraform variable is included with this repository. It includes predefined defaults, however does not include include secrets or protected information. This information should not be tracked, you can safely keep track of secrets by storing variables locally in terraform.tfvars. Terraform will use this file locally when you run it and attempt to provision your Kubernetes cluster.

In order to start using the sample terraform.tfvars file run the following command:

    cp examples/terraform.tfvars.example.digitalocean terraform.tfvars

After doing so, you will want to set any variables in the terraform.tfvars file that is expecting a replaced value (notably the arm_ variables).

### Provisioning

Run the command:

    ./provision.sh

If it was successful, you should be able to run:

    kubectl get pods --all-namespaces

If the provisioning completes successfully, however if you are unable to connect to your Kubernetes cluster using Kubectl you will want to verify the Kubernetes context being used and the location of the kubeconfig path.

You can do both as follows:     

    kubectl config view