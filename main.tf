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

resource "kubernetes_namespace" "terraform-demo" {
  metadata {
    annotations = {
      name = "terraform-demo"
    }

    labels = {
      app = "terraform-demo"
    }

    name = "terraform-demo"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-example"
    namespace= "terraform-demo"
    labels = {
      app = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          app = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = var.image_tag
          name  = "nginx-example"

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
resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.terraform-demo.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.terraform-demo.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }
}
