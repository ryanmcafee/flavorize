# Common to all k8s provisioning

# Valid options are: cloudflare, none
certmanager_provider="none"
# Email of user that will receive issuer notifications
certmanager_email="youremail@example.com"
# Valid options are: HTTP01, DNS01
certmanager_solver="DNS01"
certmanager_helm_chart_version="0.15.0"

# Ingress Settings
# Valid options are: nginx, none
ingress_provider="nginx"
ingress_enable_proxy_protocol="true"
ingress_enable_backend_keepalive="false"
ingress_helm_chart_version="2.1.0"
ingress_num_replicas="3"
ingress_autoscaling_enabled="true"
ingress_controller_use_component_labels="true"
ingress_controller_metrics_service_monitor_enabled="true"
ingress_metrics_enabled="true"
ingress_controller_metrics_prometheusRule_enabled="true"
# Need to set to this to ensure certmanager certificate issuance works correctly for Digital Ocean
# with their load balancers. See: https://www.digitalocean.com/community/questions/how-do-i-correct-a-connection-timed-out-error-during-http-01-challenge-propagation-with-cert-manager
cluster_dns_domain="somecoolclustername.nyc3.do.example.com"

# External DNS Settings
# Valid options are: cloudflare, none
externaldns_provider="none"
externaldns_helm_chart_version="2.22.1"
# Domains that you wish to issue certs and create external dns records for
externaldns_domains="example.com"
externaldns_api_token="yourcloudflareapitoken"

# Rook Settings
rook_enabled="false"
rook_helm_chart_version="v1.3.3"
rbac_enabled="true"

# NFS Settings
nfs_server_enabled="false"
nfs_chart_version="1.0.0"
nfs_storage_class=""
nfs_persistence_enabled="enabled"
nfs_disk_size="20Gi"

# Prometheus Settings
prometheus_enabled="true"
prometheus_chart_version="8.13.8"