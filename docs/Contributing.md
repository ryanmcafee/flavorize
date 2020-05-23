# Contributing

## Adding Kubernetes Cluster Provisioning Support For Additional Cloud/On Premise Provider

In order to add support for an additional cloud provider you'll want to do the following:

1) Create an issue for the provider you are adding support for

2) Clone the repo locally

3) Create a feature branch from master

4) Navigate to the "flavors" directory and expand it.

5) Copy the "flavors/azure" folder into "flavors/yournewflavor"

6) Update the following files in the new flavor folder: k8s.tf (provider specific kubernetes cluster provisioning and calls the flavorize module), output.tf (store the kubernetes cluster info in tf state), providers.tf (terraform provider setup), variables.tf (variables specific to your new provider)

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