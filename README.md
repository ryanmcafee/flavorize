# Provision Kubernetes With Terraform

This repo is used for provisioning Kubernetes clusters declaratively using Terraform.  
Terraform is great for provisioning infrastructure across multiple providers (both on premise and cloud).  
Got a problem with your cluster? Just destroy it and bring it back up.  

Obviously, you'll want to think twice before destroying your Kubernetes cluster in production (stateful data sets, etc..),  
but when setting up your Kubernetes cluster or upgrading some of it's components (ingress controller, certmanager, externaldns, etc..) it is a great tool to use and can really help.

Kubernetes is complex and vendors often incorporate their own offerings and encourage you to use their "cloud" and "apis".
In the short term, directly utilizing cloud providers' cli sdks directly to provision kubernetes clusters seems like the way to go.
I would encourage you to not do that. Using Terraform makes setup and provisioning repeatable and reliable allowing others to reuse your infrastructure blueprint. It can also make cross cloud infrastructure deployments more easily achievable.

Currently, Azure is the only provider that this repo currently handles provisioning for, however you can add support for other providers as well. I designed the implementation to be modular and flexible to support additional cloud providers. I also plan on adding Digital Ocean support shortly. PR requests are welcome and much appreciated! Please see the [contribution guide](https://github.com/ryanmcafee/flavorize/blob/master/Contributing.md) on how to add a provider.

The terraform configuration for provisioning Kubernetes will vary slightly according to the cloud provider, so please consult your cloud provider's documentation.

# Provisioning

To setup/provision a Kubernetes cluster, follow the documentation for the appropriate provider.

[Azure](https://github.com/ryanmcafee/flavorize/blob/master/modules/k8s/azure/readme.md)

# Contributing

We welcome feedback and contributions from the open source community! Please see our contribution guide and policies [here](https://github.com/ryanmcafee/flavorize/blob/master/Contributing.md).


