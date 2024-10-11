# Récupérer le groupe de ressources s'il existe
data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

# Créer le groupe de ressources seulement s'il n'existe pas
resource "azurerm_resource_group" "hasma_rg" {
  count    = length(data.azurerm_resource_group.existing_rg) == 0 ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

# Créer le cluster AKS seulement s'il n'existe pas
resource "azurerm_kubernetes_cluster" "hasma_aks" {
  count                = length(data.azurerm_kubernetes_cluster.existing_aks) == 0 ? 1 : 0
  name                 = "abdel_HASMA_aks_cluster" # Remplacer par votre nom de cluster
  location             = azurerm_resource_group.hasma_rg[0].location
  resource_group_name  = azurerm_resource_group.hasma_rg[0].name # Correction ici
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

# Obtenir les informations d'identification AKS pour utiliser kubectl
resource "null_resource" "apply_k8s_manifests" {
  depends_on = [azurerm_kubernetes_cluster.hasma_aks]

  provisioner "local-exec" {
    command = join("\n", [
      "az aks get-credentials --resource-group ${azurerm_resource_group.hasma_rg[0].name} --name ${azurerm_kubernetes_cluster.hasma_aks[0].name}",
      "kubectl apply -f ../Back",
      "kubectl apply -f ../Front",
      "kubectl apply -f ../Back/Phpmyadmin",
      "kubectl apply -f ../Monitoring/Grafana",
      "kubectl apply -f ../Monitoring/Prometheus",
      "kubectl apply -f ../Monitoring/node-exporter --validate=false"
    ])
  }
}

# Outputs pour vérifier les valeurs créées
output "resource_group_name" {
  value = azurerm_resource_group.hasma_rg[0].name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.hasma_aks[0].name
}