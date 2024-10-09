output "aks_cluster_api_url" {
  value = azurerm_kubernetes_cluster.hasma_aks.kube_config.0.host
}
