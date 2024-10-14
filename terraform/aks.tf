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

# 3. Attendre que le cluster AKS soit disponible
resource "null_resource" "wait_for_aks" {
  depends_on = [azurerm_kubernetes_cluster.hasma_aks]

  provisioner "local-exec" {
    command = "echo 'Cluster AKS disponible.'"
  }
}

# 4. Appliquer les manifestes Kubernetes après la disponibilité du cluster
resource "null_resource" "apply_k8s_manifests" {
  depends_on = [null_resource.wait_for_aks]

  provisioner "local-exec" {
    command = <<EOT
      echo "Connexion à Azure avec le service principal..."
      az login --service-principal -u ${var.appId} -p ${var.password} --tenant ${var.tenant_id}
      
      echo "Récupération des identifiants du cluster AKS..."
      az aks get-credentials --resource-group ${azurerm_resource_group.hasma_rg.name} --name ${azurerm_kubernetes_cluster.hasma_aks.name} --overwrite-existing
      
      echo "Vérification de la disponibilité de l'API Kubernetes..."
      for i in {1..30}; do
        kubectl cluster-info && break
        echo "L'API Kubernetes n'est pas encore prête, réessai dans 10 secondes..."
        sleep 10
      done
     
      echo "Exécution du playbook Ansible pour créer le namespace..."
      ansible-playbook ../ansible/playbooks/create_namespace.yml -e "namespace_name=hasma-namespace kubeconfig_path=../.kube/config"

      echo "Application des manifestes Kubernetes..."
      # kubectl apply -f ../Back --validate=false
      # kubectl apply -f ../Front --validate=false
      # kubectl apply -f ../Back/Phpmyadmin --validate=false
      # kubectl apply -f ../Monitoring/Grafana --validate=false
      # kubectl apply -f ../Monitoring/Prometheus --validate=false
      # kubectl apply -f ../Monitoring/node-exporter --validate=false
    EOT
  }
}