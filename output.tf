# --- Output ---

output "proxy_global_ip" {
  value       = aws_instance.proxy.public_ip
  description = "the IP-Adress of the front door"
}

output "proxy_global_domain" {
  value       = aws_instance.proxy.public_dns
  description = "the Domainame of the front door"
}

resource "null_resource" "auto_open" {

  depends_on = [
    aws_instance.backend_a
  ]

  provisioner "local-exec" {


    command = "open http://${aws_instance.proxy.public_dns}"

    on_failure = continue
  }
}