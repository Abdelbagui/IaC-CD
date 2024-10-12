### Documentation du Projet : Déploiement d'une Stack WordPress + MySQL + Monitoring sur AKS avec Terraform et GitHub Actions

---

#### Table des matières

1. **Introduction**
2. **Objectifs**
3. **Technologies Utilisées**
4. **Architecture du Projet**
5. **Prérequis**
6. **Structure du Répertoire**
7. **Étapes du Déploiement**
    - a. Infrastructure (AKS) avec Terraform
    - b. Déploiement des Applications (WordPress + MySQL)
    - c. Monitoring (Prometheus + Grafana)
8. **GitHub Actions - CI/CD Pipeline**
9. **Secrets et Configuration**
10. **Commandes Utiles**
11. **Destruction de l'Infrastructure**
12. **Conclusion**

---

### 1. Introduction

Ce projet vise à automatiser la création d'une infrastructure cloud et le déploiement d'applications sur un cluster **AKS (Azure Kubernetes Service)**. L'objectif est de déployer une stack composée de **WordPress** (front-end), **MySQL** (base de données) et des outils de **monitoring** (Prometheus et Grafana). Le tout est orchestré par **Terraform** pour l'infrastructure et un pipeline **GitHub Actions** pour l'automatisation du déploiement.

---

### 2. Objectifs

- Créer automatiquement une infrastructure Azure avec un cluster AKS.
- Déployer une application WordPress connectée à une base de données MySQL.
- Configurer un système de monitoring avec Prometheus et Grafana.
- Mettre en place un pipeline CI/CD pour automatiser la création de l'infrastructure et le déploiement des applications.

---

### 3. Technologies Utilisées

- **Terraform** : Infrastructure as Code pour la création du cluster AKS sur Azure.
- **Azure Kubernetes Service (AKS)** : Hébergement du cluster Kubernetes.
- **GitHub Actions** : Automatisation des étapes CI/CD.
- **MySQL** : Base de données pour WordPress.
- **WordPress** : Système de gestion de contenu déployé sur Kubernetes.
- **Prometheus** : Solution de monitoring pour Kubernetes.
- **Grafana** : Dashboard de visualisation des métriques.
- **kubectl** : Interface en ligne de commande pour interagir avec Kubernetes.

---

### 4. Architecture du Projet

L'architecture du projet se compose des éléments suivants :

1. **Azure Kubernetes Service (AKS)** :
   - Cluster Kubernetes pour héberger WordPress, MySQL et les outils de monitoring.
   
2. **MySQL** :
   - Service de base de données pour WordPress.

3. **WordPress** :
   - Application front-end déployée sur Kubernetes.

4. **Prometheus & Grafana** :
   - Stack de monitoring pour surveiller les performances de l'infrastructure.

---

### 5. Prérequis

- Compte Azure avec un abonnement actif.
- Secrets configurés dans **GitHub** pour interagir avec Azure (plus d'infos dans la section "Secrets et Configuration").
- Terraform installé localement pour les tests (optionnel).
- Compte GitHub avec accès à GitHub Actions.
- Familiarité avec Kubernetes et `kubectl`.

---

### 6. Structure du Répertoire

```
├── terraform/
│   └── main.tf              # Fichier principal Terraform pour déployer AKS
│   └── variables.tf         # Définition des variables Terraform
│   └── outputs.tf           # Sorties Terraform (URL AKS, etc.)
├── Back/
│   └── mysql-deployment.yaml # Manifest Kubernetes pour MySQL
│   └── mysql-service.yaml    # Service Kubernetes pour MySQL
├── Front/
│   └── wordpress-deployment.yaml # Manifest Kubernetes pour WordPress
│   └── wordpress-service.yaml    # Service Kubernetes pour WordPress
├── Monitoring/
│   └── prometheus-deployment.yaml # Manifest Kubernetes pour Prometheus
│   └── grafana-deployment.yaml    # Manifest Kubernetes pour Grafana
└── .github/
    └── workflows/
        └── deploy.yml            # Pipeline GitHub Actions pour CI/CD
```

---

### 7. Étapes du Déploiement

#### a. Infrastructure (AKS) avec Terraform

Le fichier `main.tf` de Terraform est utilisé pour créer un cluster AKS sur Azure. Le backend Terraform utilise un compte de stockage Azure pour stocker l'état de l'infrastructure.

- **Commandes** :
  - `terraform init`: Initialise Terraform et configure le backend.
  - `terraform plan`: Génère le plan d'exécution pour la création de l'infrastructure.
  - `terraform apply`: Crée ou modifie l'infrastructure définie dans les fichiers Terraform.

#### b. Déploiement des Applications (WordPress + MySQL)

Les manifestes Kubernetes pour MySQL et WordPress sont stockés dans les dossiers `Back` et `Front` respectivement.

- **MySQL** : Fichiers YAML dans le dossier `Back`.
  - `mysql-deployment.yaml`: Définit le déploiement de MySQL.
  - `mysql-service.yaml`: Définit le service exposant MySQL au cluster.

- **WordPress** : Fichiers YAML dans le dossier `Front`.
  - `wordpress-deployment.yaml`: Définit le déploiement de WordPress.
  - `wordpress-service.yaml`: Définit le service exposant WordPress via un LoadBalancer.

#### c. Monitoring (Prometheus + Grafana)

Les fichiers YAML pour Prometheus et Grafana sont dans le dossier `Monitoring`.

- **Prometheus** : Monitor Kubernetes et collecte les métriques.
- **Grafana** : Interface pour visualiser les données de Prometheus.

---

### 8. GitHub Actions - CI/CD Pipeline

Le fichier `deploy.yml` dans le dossier `.github/workflows/` définit le pipeline CI/CD. Il s'agit d'un workflow GitHub Actions qui déclenche le déploiement sur chaque `push` dans la branche `main`.

#### Étapes du pipeline :
1. **Checkout** : Récupération du code source depuis GitHub.
2. **Install dependencies** : Installation des dépendances requises (`kubectl`, Terraform).
3. **Terraform Init & Apply** : Création du cluster AKS avec Terraform.
4. **kubectl** : Déploiement des manifestes MySQL, WordPress, Prometheus et Grafana sur le cluster AKS.
5. **Clean up** : Nettoyage des fichiers temporaires.

---

### 9. Secrets et Configuration

Les secrets suivants doivent être configurés dans GitHub pour permettre l'interaction avec Azure et Terraform :

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`

Pour configurer les secrets :
1. Allez dans **Settings > Secrets** de votre dépôt GitHub.
2. Ajoutez les secrets mentionnés ci-dessus.

---

### 10. Commandes Utiles

- **Terraform** :
  - `terraform init`: Initialisation du backend.
  - `terraform plan`: Prévisualiser les modifications avant l'application.
  - `terraform apply`: Appliquer les modifications d'infrastructure.
  - `terraform destroy`: Détruire l'infrastructure.

- **kubectl** :
  - `kubectl apply -f <file>`: Déployer un manifest YAML sur Kubernetes.
  - `kubectl get pods`: Vérifier les pods en cours d'exécution.
  - `kubectl logs <pod>`: Afficher les logs d'un pod.

---

### 11. Destruction de l'Infrastructure

Pour détruire l'infrastructure après utilisation, vous pouvez soit utiliser Terraform directement, soit intégrer une étape `destroy` dans votre pipeline CI/CD.

- **Commande** :
  ```bash
  terraform destroy -auto-approve
  ```

Vous pouvez aussi ajouter un job GitHub Actions pour automatiser cette étape.

---

### 12. Conclusion

Ce projet met en place une infrastructure complète sur Azure, comprenant un cluster AKS et une stack d'applications WordPress + MySQL avec monitoring (Prometheus + Grafana). Le tout est automatisé avec un pipeline CI/CD via GitHub Actions. Grâce à Terraform, la gestion de l'infrastructure devient reproductible, et Kubernetes permet de déployer et de gérer les applications à grande échelle.

Cette solution est extensible et peut être adaptée à des besoins futurs, tels que le déploiement d'autres applications ou l'intégration de nouvelles fonctionnalités comme le scaling automatique ou l'ajout de certificats SSL.

---

### Annexes

- **Liens utiles** :
  - [Terraform Documentation](https://www.terraform.io/docs)
  - [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/)
  - [GitHub Actions Documentation](https://docs.github.com/en/actions)