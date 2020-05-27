# Flavorize Your Kubernetes Provisioning

Flavorize aims to make it easy to setup and provision a fully working Kubernetes cluster in as little time as possible (under 1 hr) while also provisioning the common things like a load balancer,  automatic ssl issuance (from ACME providers like Lets Encrypt) and creation of external dns records for services deployed to the cluster, etc. It's aim is to automate the routine stuff and get a fully working Kubernetes cluster provisioned declaratively using IaC (Infrastructure As Code). This allow you to experiment when you have the time, tear it down when you're done (save on cloud costs) and overall allows you to focus on the fun parts of cloud native development. Who doesn't like moving fast and having fun? Now, let's inject some flavor into Kubernetes!    

# Quick Start - Provisioning a Kubernetes Cluster

To setup/provision a Kubernetes cluster, follow the documentation for the appropriate provider. The following guides make it possible to setup a Kubernetes cluster in under 1 hr, on your pick of cloud provider. Your mileage will vary based on your knowledge and experience, but I have aimed to make the setup as streamlined as possible to help encourage the adoption and usage of Kubernetes and other cloud native technologies. Flavorize is now baked into my workflow and can't imagine using Kubernetes without it. I have built kubernetes "flavors" for Azure as well as Digital Ocean of which you may find quick starts on how to use below.

[Azure](flavors/azure/readme.md)        

[Digital Ocean](flavors/digitalocean/readme.md)

# Contributing

Currently, Azure and Digital Ocean are the only providers that this repo currently handles provisioning for, however you can add support for other providers as well. I designed the implementation to be modular and flexible to support additional cloud providers. There are issues open now to track support for other providers. Feel free to open an issue if you don't see your provider listed here. PR requests are welcome and much appreciated! Please see the [contribution guide](docs/Contributing.md) on how to add a provider or additional Kubernetes provisioning components.

The terraform configuration for provisioning Kubernetes will vary slightly according to the cloud provider so please consult your cloud provider's documentation.

We welcome feedback and contributions from the open source community! Please see our contribution guide and policies [here](docs/Contributing.md).  


