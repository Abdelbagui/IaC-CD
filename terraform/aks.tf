# Récupérer le groupe de ressources s'il existe
data "azurerm_resource_group" "existing_rg" {
  count = length(try(var.resource_group_name)) > 0 ? 1 : 0
  name  = var.resource_group_name
}

# Récupérer le cluster AKS s'il existe
data "azurerm_kubernetes_cluster" "existing_aks" {
  count               = length(try(var.kubernetes_cluster_name)) > 0 ? 1 : 0
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}

# Créer le groupe de ressources seulement s'il n'existe pas
resource "azurerm_resource_group" "hasma_rg" {
  count    = data.azurerm_resource_group.existing_rg.count == 0 ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

# Créer le cluster AKS seulement s'il n'existe pas
resource "azurerm_kubernetes_cluster" "hasma_aks" {
  count                = data.azurerm_kubernetes_cluster.existing_aks.count == 0 ? 1 : 0
  name                 = var.kubernetes_cluster_name
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
  depends_on = [
    azurerm_kubernetes_cluster.hasma_aks,
    data.azurerm_kubernetes_cluster.existing_aks
  ]

  provisioner "local-exec" {
    command = <<EOT
      echo "Attente que le cluster AKS soit prêt..."
      while ! az aks show --resource-group ${data.azurerm_resource_group.existing_rg.count > 0 ? data.azurerm_resource_group.existing_rg[0].name : azurerm_resource_group.hasma_rg[0].name} --name ${data.azurerm_kubernetes_cluster.existing_aks.count > 0 ? data.azurerm_kubernetes_cluster.existing_aks[0].name : azurerm_kubernetes_cluster.hasma_aks[0].name} --query "powerState" -o tsv | grep -q "Running"; do
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
      "az aks get-credentials --resource-group ${data.azurerm_resource_group.existing_rg.count > 0 ? data.azurerm_resource_group.existing_rg[0].name : azurerm_resource_group.hasma_rg[0].name} --name ${data.azurerm_kubernetes_cluster.existing_aks.count > 0 ? data.azurerm_kubernetes_cluster.existing_aks[0].name : azurerm_kubernetes_cluster.hasma_aks[0].name}",
      "kubectl apply -f ../Back",
      "kubectl apply -f ../Front",
      "kubectl apply -f ../Back/Phpmyadmin",
      "kubectl apply -f ../Monitoring/Grafana",
      "kubectl apply -f ../Monitoring/Prometheus",
      "kubectl apply -f ../Monitoring/node-exporter --validate=false"
    ])
  }
}