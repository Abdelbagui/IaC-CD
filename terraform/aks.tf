# Récupération des informations du groupe de ressources existant
data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

# Récupération des informations du cluster AKS existant
data "azurerm_kubernetes_cluster" "existing_aks" {
  name                = "abdel_HASMA_aks_cluster"  # Changez ceci si nécessaire
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Définition du groupe de ressources (ne sera pas créé si existant)
resource "azurerm_resource_group" "hasma_rg" {
  count    = length(data.azurerm_resource_group.existing_rg) == 0 ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

# Définition du cluster Kubernetes (ne sera pas créé si existant)
resource "azurerm_kubernetes_cluster" "hasma_aks" {
  count                = length(data.azurerm_kubernetes_cluster.existing_aks) == 0 ? 1 : 0
  name                 = "abdel_HASMA_aks_cluster"
  location             = azurerm_resource_group.hasma_rg[0].location
  resource_group_name  = azurerm_resource_group.hasma_rg[0].name
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
  depends_on = [azurerm_kubernetes_cluster.hasma_aks]

  provisioner "local-exec" {
    command = <<EOT
      echo "Attente que le cluster AKS soit prêt..."
      while ! az aks show --resource-group ${azurerm_resource_group.hasma_rg[0].name} --name ${azurerm_kubernetes_cluster.hasma_aks[0].name} --query "powerState" -o tsv | grep -q "Running"; do
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
      "az aks get-credentials --resource-group ${azurerm_resource_group.hasma_rg[0].name} --name ${azurerm_kubernetes_cluster.hasma_aks[0].name}",
      for file in [
        "../Back",
        "../Front",
        "../Back/Phpmyadmin",
        "../Monitoring/Grafana",
        "../Monitoring/Prometheus",
        "../Monitoring/node-exporter"
      ] : "kubectl apply -f ${file} ${file == "../Monitoring/node-exporter" ? '--validate=false' : ''}"
    ])
  }
}