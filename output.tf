# --- Output ---

output "frontend_global_ip" {
  value = aws_instance.app_server.public_ip
 
}

output "backend_global_ip" {
  value = aws_instance.backend

}