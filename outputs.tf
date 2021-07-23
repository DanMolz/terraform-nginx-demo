output "nginx_load_balancer_ip" {
  value = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip
  description = "Connect to the nginx using this ip address"
}
