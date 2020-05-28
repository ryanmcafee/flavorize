# Specific to digitalocean cloud_provider
cloud_provider="do"
# Controls horizontal Kubernetes auto scaling (enable or disable it)
enable_auto_scaling="false"
# Specifies the location that the cluster will be deployed in
location="nyc3"
# How many Kubernetes nodes should be provisioned in the cluster node pool?
agent_count="1"
# Used in conjunction when enable_auto_scaling="true"
# At the minimum (scalein), how many Kubernetes nodes should be running in your cluster? 
autoscale_min_count="1"
# At the max (scaleout), how many Kubernetes nodes should be running in your cluster? 
autoscale_max_count="2"
# What should the default node pool be called? (Included in Digital Ocean droplet name)
default_node_pool_name="k8s-agentpool"
# The droplet vm size to use for a given worker node in the Kubernetes cluster.
default_node_pool_vm_size="s-2vcpu-4gb"
# A distinct name you can use to identify your k8s cluster
cluster_name="digitalocean-k8s"
# What version of k8s do you want to deploy?
kubernetes_version="1.17.5-do.0"
# Examples: Production, Staging, Qa, Test, Dr, Dev, etc..
environment="dev"
# Examples: Department/Role (DevOps), Person, etc..
operator="DevOps"
# You can generate a token in the control panel at https://cloud.digitalocean.com/account/api/tokens
do_token="yourdigitaloceanapitoken"