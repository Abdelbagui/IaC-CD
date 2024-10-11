# output "aks_cluster_api_url" {
#   value = length(data.azurerm_kubernetes_cluster.existing_aks) > 0 ? data.azurerm_kubernetes_cluster.existing_aks[0].kube_admin_config : azurerm_kubernetes_cluster.hasma_aks[0].kube_admin_config
# sensitive = true
# }

# output "aks_cluster_name" {
#   value = length(data.azurerm_kubernetes_cluster.existing_aks) > 0 ? data.azurerm_kubernetes_cluster.existing_aks[0].name : azurerm_kubernetes_cluster.hasma_aks[0].name
# }