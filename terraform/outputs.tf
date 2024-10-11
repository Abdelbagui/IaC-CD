output "aks_cluster_api_url" {
  value     = length(data.azurerm_kubernetes_cluster.existing_aks) > 0 ? data.azurerm_kubernetes_cluster.existing_aks.kube_admin_config : azurerm_kubernetes_cluster.hasma_aks[0].kube_admin_config
  sensitive = true  # Marquer comme sensible
}

output "aks_cluster_name" {
  value     = length(data.azurerm_kubernetes_cluster.existing_aks) > 0 ? data.azurerm_kubernetes_cluster.existing_aks.name : azurerm_kubernetes_cluster.hasma_aks[0].name
  sensitive = false # Pas sensible
}

output "resource_group_name" {
  value     = length(data.azurerm_resource_group.existing_rg) > 0 ? data.azurerm_resource_group.existing_rg.name : azurerm_resource_group.hasma_rg[0].name
  sensitive = false # Pas sensible
}