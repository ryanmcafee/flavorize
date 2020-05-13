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

    docker run -it --rm -v ${pwd}:/workspace ryanmcafee/devops-cli bash

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

### Log into Digital Ocean (Via CLI)

```
doctl auth init
```

You will be asked to enter your DigitalOcean access token. You can generate a token in the control panel at https://cloud.digitalocean.com/account/api/tokens
Copy and paste the token in and press enter.  
This will set the auth token so you will be able to utilize the digital ocean cli tool to retrieve available options you can set and control in terraform.tfvars
Make sure to store this token, you will need it in the next section.

### Set up your terraform variables file

A sample terraform variable is included with this repository. It includes predefined defaults, however it does not include secrets or protected information. This information should not be tracked, you can safely keep track of secrets by storing variables locally in terraform.tfvars. Terraform will use this file locally when you run it and attempt to provision your Kubernetes cluster.

In order to start using the sample terraform.tfvars file for Digital Ocean run the following command from the root project directory:

    cp examples/terraform.tfvars.example.digitalocean terraform.tfvars

After doing so, you will want to set any variables in the terraform.tfvars file that is expecting a replaced value (notably the do_token).

### Available Variables (terraform.tfvars)

// This sets the provider to digital ocean - Required       
cloud_provider="digitalocean"

// This is your Digital Ocean Api Token which grants terraform the ability to talk to the Digital Ocean api and create resources. - Required        
do_token="yourdigitaloceanapitoken"

// What you want to call your Kubernetes Cluster and how it appears online and via the api.     
cluster_name="k8s-do"

// The data center location for your Kubernetes Cluster     
// Grab the latest available regions by running the command `doctl kubernetes options regions`      
location="nyc3"

// The Kubernetes version that you want to provision        
// Grab the latest available kubernetes versions by running the command `doctl kubernetes options versions`     
kubernetes_version="1.17.5-do.0"

// The name of the default node pool (workers in the kubernetes cluster)        
default_node_pool_name="agentpool"

// The vm size that should be used for the workers      
// Grab the latest available kubernetes vm sizes by running the command `doctl kubernetes options sizes`        
default_node_pool_vm_size="s-2vcpu-2gb"

// The number of worker nodes to provision. This is the base number of worker node instances.       
agent_count="1"

// Should auto scaling be enabled to support automatic horizontal scaling?      
enable_auto_scaling="true"

// The minimum number of nodes that should be available in the autoscaling pool     
autoscale_min_count="1"

// The maximum number of instances that be in the autoscaling pool      
autoscale_max_count="3"

// Set to an environment name of your choosing      
environment="dev"

// Set to who will be the operator (Ie..Department, Role, Individual)       
operator="DevOps"

// Valid options are: cloudflare, none      
certmanager_provider="none"     

// Valid options are: cloudflare, none      
externaldns_provider="none"     

// Valid options are: nginx, none       
ingress_provider="nginx"        

// Helm chart versions      
certmanager_helm_chart_version="0.15.0"     
externaldns_helm_chart_version="2.22.1"     
ingress_helm_chart_version="2.1.0"      

// Domains that you wish to issue certs and create external dns records for     
dns_domains=""      

// Your cloudflare legacy api key       
dns_api_key=""      

// Your cloudflare account email address        
dns_api_email=""        

### Provisioning

Confirm that you have set the variables correctly in terraform.tfvars before running the following command to setup the cluster.

Run the command:

    ./provision.sh

Take a break, this should take between 5-10 minutes.    

If it was successful, you should be able to run:

    kubectl get pods --all-namespaces