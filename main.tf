terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "terraform-demo-nginx" {
  metadata {
    annotations = {
      name = "terraform-demo-nginx"
    }

    labels = {
      app = "terraform-demo-nginx"
    }

    name = "terraform-demo-nginx"
  }
}

resource "kubernetes_deployment" "terraform-demo-nginx" {
  metadata {
    name = "terraform-demo-nginx"
    namespace= "terraform-demo-nginx"
    labels = {
      app = "terraform-demo-nginx"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "terraform-demo-nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "terraform-demo-nginx"
        }
      }
      spec {
        container {
          image = var.image_tag
          name  = "terraform-demo-nginx"

          port {
            container_port = var.nginx_port
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
resource "kubernetes_service" "terraform-demo-nginx" {
  metadata {
    name      = "terraform-demo-nginx"
    namespace = kubernetes_namespace.terraform-demo.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }
}
