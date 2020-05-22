output "client_key" {
    value = module.k8s.client_key
}

output "client_certificate" {
    value = module.k8s.client_certificate
}

output "cluster_ca_certificate" {
    value = module.k8s.cluster_ca_certificate
 }

output "kube_config" {
    value = module.k8s.kube_config
}

output "token" {
    value = module.k8s.token
}

output "host" {
    value = module.k8s.host
}

output "cloud_provider" {
    value = var.cloud_provider
}