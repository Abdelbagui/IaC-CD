# Créer le groupe de ressources seulement s'il n'existe pas
resource "azurerm_resource_group" "hasma_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Vérifier si le groupe de ressources existe avant de continuer

# Créer le cluster AKS seulement s'il n'existe pas
resource "azurerm_kubernetes_cluster" "hasma_aks" {
  name                 = var.kubernetes_cluster_name
  location             = var.location
  resource_group_name  = var.resource_group_name.name
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

# Vérification que le cluster AKS est opérationnel
resource "null_resource" "wait_for_aks" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Attente que le cluster AKS soit prêt..."
      while ! az aks show --resource-group ${azurerm_resource_group.hasma_rg.name} --name ${azurerm_kubernetes_cluster.hasma_aks.name} --query "powerState" -o tsv | grep -q "Running"; do
        echo "Le cluster AKS n'est pas encore prêt. Attente de 10 secondes..."
        sleep 10
      done
      echo "Le cluster AKS est prêt !"
    EOT
  }
}

# Obtenir les informations d'identification AKS pour utiliser kubectl
resource "null_resource" "apply_k8s_manifests" {
  depends_on = [null_resource.wait_for_aks]

  provisioner "local-exec" {
    command = join("\n", [
      "az aks get-credentials --resource-group ${azurerm_resource_group.hasma_rg.name} --name ${azurerm_kubernetes_cluster.hasma_aks.name}",
      "kubectl apply -f ../Back",
      "kubectl apply -f ../Front",
      "kubectl apply -f ../Back/Phpmyadmin",
      "kubectl apply -f ../Monitoring/Grafana",
      "kubectl apply -f ../Monitoring/Prometheus",
      "kubectl apply -f ../Monitoring/node-exporter --validate=false"
    ])
  }
}
