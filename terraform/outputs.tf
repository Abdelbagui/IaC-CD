output "aks_cluster_name" {
  value = length(azurerm_kubernetes_cluster.hasma_aks) > 0 ? azurerm_kubernetes_cluster.hasma_aks[0].name : "Cluster non créé"
}

output "aks_cluster_api_url" {
  value = length(azurerm_kubernetes_cluster.hasma_aks) > 0 ? azurerm_kubernetes_cluster.hasma_aks[0].fqdn : "Cluster non créé"
  sensitive = true 
}

output "resource_group_name" {
  value = azurerm_resource_group.hasma_rg.name
}