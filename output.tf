# --- Output ---
/* 
output "proxy_global_ip" {
  value       = aws_instance.proxy.public_ip
  description = "the IP-Adress of the front door"
}

output "frontend_global_ip" {
  value       = aws_instance.frontend[0].public_ip
  description = "the IP-Adress of the fontend instance"
}

output "backend_public_ip" {
  value       = aws_instance.backend_a[0].public_ip
  description = "the IP-Adress of the backend instance"
} */