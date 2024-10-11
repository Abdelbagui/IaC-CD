output "aks_cluster_api_url" {
  value = azurerm_kubernetes_cluster.hasma_aks[0].id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.hasma_aks[0].name
}

output "resource_group_name" {
  value = azurerm_resource_group.hasma_rg[0].name
}