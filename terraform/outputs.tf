output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.hasma_aks.name
}

output "aks_cluster_api_url" {
  value     = azurerm_kubernetes_cluster.hasma_aks.fqdn
  sensitive = true 
}

output "resource_group_name" {
  value = azurerm_resource_group.hasma_rg.name
}