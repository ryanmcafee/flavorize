output "id" {
    value = digitalocean_kubernetes_cluster.k8s[0].id
}

output "host" {
    value = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.host
}

output "token" {
    value = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.token
}

output "client_key" {
    value = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.client_key
}

output "client_certificate" {
    value = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
    value = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.cluster_ca_certificate
}

output "kube_config" {
    value = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.raw_config
}

output "cloud_provider" {
    value = var.cloud_provider
}