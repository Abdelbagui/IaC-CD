# 1. Créer le groupe de ressources
resource "azurerm_resource_group" "hasma_rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Créer le cluster AKS
resource "azurerm_kubernetes_cluster" "hasma_aks" {
  name                 = var.kubernetes_cluster_name
  location             = azurerm_resource_group.hasma_rg.location
  resource_group_name  = azurerm_resource_group.hasma_rg.name
  dns_prefix           = "hasmak8s"
  
  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }
}

# 3. Appliquer les manifestes Kubernetes après création du cluster
resource "null_resource" "apply_k8s_manifests" {
  depends_on = [azurerm_kubernetes_cluster.hasma_aks]

  provisioner "local-exec" {
    command = <<EOT
      az aks get-credentials --resource-group ${azurerm_resource_group.hasma_rg.name} --name ${azurerm_kubernetes_cluster.hasma_aks.name} --overwrite-existing
      kubectl apply -f ../Back --validate=false
      kubectl apply -f ../Front --validate=false
      kubectl apply -f ../Back/Phpmyadmin --validate=false
      kubectl apply -f ../Monitoring/Grafana --validate=false
      kubectl apply -f ../Monitoring/Prometheus --validate=false
      kubectl apply -f ../Monitoring/node-exporter --validate=false
    EOT
  }
}