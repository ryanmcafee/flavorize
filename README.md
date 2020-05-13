# Project Overview

This repo is used for provisioning Kubernetes clusters declaratively using Terraform.  
Terraform is great for provisioning infrastructure across multiple providers (both on premise and cloud).  
Got a problem with your cluster? Just destroy it and bring it back up.  

Obviously, you'll want to think twice before destroying your Kubernetes cluster in production (stateful data sets, etc..),  
but when setting up your Kubernetes cluster or upgrading some of it's components (ingress controller, certmanager, externaldns, etc..) it is a great tool to use and can really help.

Kubernetes is complex and vendors often incorporate their own offerings and encourage you to use their "cloud" and "apis".
In the short term, directly utilizing cloud providers' cli sdks directly to provision kubernetes clusters seems like the way to go.
I would encourage you to not do that. Using Terraform makes setup and provisioning repeatable and reliable allowing others to reuse your infrastructure blueprint. It can also make cross cloud infrastructure deployments more easily achievable.

Flavorize aims to make it easy to setup and provision a fully working Kubernetes cluster in as little time as possible while also provisioning the common things like a load balancer, automatic ssl issuance (from ACME providers like LetsEncrypt) and creation of external dns records for services deployed to the cluster, etc. It's aim is to automate the routine stuff, so you can focus on the fun parts of cloud native development. Who doesn't like moving fast and having fun? Now, let's inject some flavor into Kubernetes!

# Quick Start - Provisioning a Kubernetes Cluster

To setup/provision a Kubernetes cluster, follow the documentation for the appropriate provider. The following guides make it possible to setup a Kubernetes cluster in under 1 hr. Your mileage will vary based on your 
knowledge and experience, but I have aimed to make the setup as streamlined as possible to help encourage the adoption and usage of Kubernetes and other cloud native technologies.

[Azure](https://github.com/ryanmcafee/flavorize/blob/master/docs/providers/Azure.md)        

[Digital Ocean](https://github.com/ryanmcafee/flavorize/blob/master/docs/providers/DigitalOcean.md)

# Contributing

Currently, Azure and Digital Ocean are the only providers that this repo currently handles provisioning for, however you can add support for other providers as well. I designed the implementation to be modular and flexible to support additional cloud providers. There are issues open now to track support for other providers. Feel free to open an issue if you don't see your provider listed here or in an open issue. PR requests are welcome and much appreciated! Please see the [contribution guide](https://github.com/ryanmcafee/flavorize/blob/master/docs/Contributing.md) on how to add a provider.

The terraform configuration for provisioning Kubernetes will vary slightly according to the cloud provider, so please consult your cloud provider's documentation.

We welcome feedback and contributions from the open source community! Please see our contribution guide and policies [here](https://github.com/ryanmcafee/flavorize/blob/master/docs/Contributing.md).


