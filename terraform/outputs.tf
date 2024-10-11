
# Outputs
output "resource_group_name" {
  value = azurerm_resource_group.hasma_rg.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.hasma_aks[0].name
}