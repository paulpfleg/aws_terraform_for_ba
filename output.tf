# --- Output ---

output "proxy_global_ip" {
  value       = aws_instance.proxy.public_ip
  description = "the IP-Adress of the front door"
}

