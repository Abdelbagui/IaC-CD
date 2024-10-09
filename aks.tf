resource "azurerm_resource_group" "hasma_rg" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_kubernetes_cluster" "hasma_aks" {
  name                = "abdel_HASMA_aks_cluster"
  location            = azurerm_resource_group.hasma_rg.location
  resource_group_name = azurerm_resource_group.hasma_rg.name
  dns_prefix          = "hasmak8s"

  default_node_pool {
    name       = "default"
    node_count = 2
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

# 3. Obtenir les informations d'identification AKS pour utiliser kubectl
resource "null_resource" "apply_k8s_manifests" {
  depends_on = [azurerm_kubernetes_cluster.hasma_aks]

  # Utiliser local-exec pour exécuter la commande kubectl
  provisioner "local-exec" {
    command = <<EOT
      az aks get-credentials --resource-group ${azurerm_resource_group.hasma_rg.name} --name ${azurerm_kubernetes_cluster.hasma_aks.name}
      kubectl apply -f ../Back
      kubectl apply -f ../Front
      kubectl apply -f ../Back/Phpmyadmin
      kubectl apply -f ../Monitoring/Grafana
      kubectl apply -f ../Monitoring/Prometheus
      kubectl apply -f ../Monitoring/node-exporter  --validate=false    
    EOT
  }
}