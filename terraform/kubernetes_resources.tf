##################################################
# Kubernetes Resources for Web Server Deployment
##################################################

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  token                  = data.aws_eks_cluster_auth.this.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
}

# Creates a namespace
resource "kubernetes_namespace" "web" {
  metadata {
    name = "webserver"
  }
}

# Defines a Kubernetes Deployment and deploys multiple replicas (pods) of the web server
resource "kubernetes_service_account" "web" {
  metadata {
    name      = "web-sa"
    namespace = kubernetes_namespace.web.metadata[0].name
  }
}

# Runs 2 replicas of the web server, defines pods, assign the Kubernetes Service to the pods and use Docker iamge
resource "kubernetes_deployment" "web" {
  metadata {
    name      = "webserver"
    namespace = kubernetes_namespace.web.metadata[0].name
    labels = {
      app = "webserver"
    }
  }

  spec {
    replicas = 2  # Define the number of pods running the application
    selector {
      match_labels = {
        app = "webserver"
      }
    }

    template {
      metadata {
        labels = {
          app = "webserver"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.web.metadata[0].name

        container {
          name  = "webserver"
          image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-web-app:latest"  # Replace with your ECR repository
          port {
            container_port = 3000
          }

          env {
            name  = "PORT"
            value = "3000"
          }
        }
      }
    }
  }
}

# Creates a Kubernetes Service to expose the webserver and redirects incoming traffic
resource "kubernetes_service" "web" {
  metadata {
    name      = "webserver-service"
    namespace = kubernetes_namespace.web.metadata[0].name
  }

  spec {
    selector = {
      app = "webserver"
    }

    port {
      port        = 80
      target_port = 3000
    }
    # Expose web server using LoadBalancer service"
    type = "LoadBalancer"
  }
}
