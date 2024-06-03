# K8s Deployment for a microservice 
# Reference :https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider?variants=kubernetes%3Aeks

resource "kubernetes_deployment" "microservice-1" {
  metadata {
    name = "microservice-1"
    labels = {
      app = "microservice-1"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "microservice-1"
      }
    }
    template {
      metadata {
        labels = {
          app = "microservice-1"
        }
      }
      spec {
        container {
          image = "your-registry-url/microservice-1:latest"
          name  = "microservice-1"
          
          port {
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

# Define Kubernetes Service for Microservice-1
resource "kubernetes_service" "microservice-1" {
  metadata {
    name = "microservice-1"
  }

  spec {
    selector = {
      app = "microservice-1"
    }

    port {
      port        = 80
      target_port = 8081
    }
    # Define type as "ClusterIP", "NodePort", or "LoadBalancer" as per the requirement
    type = "Loadbalancer"
  }
}

resource "kubernetes_deployment" "microservice-2" {
  metadata {
    name = "microservice-2"
    labels = {
      app = "microservice-2"
    }
  }

  spec {
    replicas = 4
    selector {
      match_labels = {
        app = "microservice-2"
      }
    }
    template {
      metadata {
        labels = {
          app = "microservice-2"
        }
      }
      spec {
        container {
          image = "your-registry-url/microservice-2:latest"
          name  = "microservice-2"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "microservice-2" {
  metadata {
    name = "microservice-2"
  }

  spec {
    selector = {
      app = "microservice-2"
    }

    port {
      port        = 80
      target_port = 8081
    }
    type = "Loadbalancer"
  }
}




# Define Kubernetes Ingress for Microservice-1
resource "kubernetes_ingress" "app-ingress" {
  metadata {
    name = "app-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "microservice.example.com"
      http {
        path {
          path = "/microservice-1"
          backend {
            service_name = kubernetes_service.microservice-1.metadata[0].name
            service_port = kubernetes_service.microservice-1.spec[0].port[0].port
          }
        }
        path {
          path = "/microservice-2"
          backend {
            service_name = kubernetes_service.microservice-2.metadata[0].name
            service_port = kubernetes_service.microservice-2.spec[0].port[0].port
          }
        }
      }
    }
  }
}

