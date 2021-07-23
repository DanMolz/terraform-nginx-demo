output "nginx service ip address" {
  value       = aws_db_instance.example.address
  description = "Connect to the nginx using this ip address"
}

output "load_balancer_ip" {
  value = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip
}
