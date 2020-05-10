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