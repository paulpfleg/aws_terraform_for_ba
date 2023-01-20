# --- Output provides some usefull info after the apply process ---


# outputs the Proxys IP
output "proxy_global_ip" {
  value       = aws_instance.proxy.public_ip
  description = "the IP-Adress of the front door"
}

# outputs the Proxys DNS-Name
output "proxy_global_domain" {
  value       = aws_instance.proxy.public_dns
  description = "the Domainame of the front door"
}


# last Step: opens the webpage
resource "null_resource" "auto_open" {
  depends_on = [
    aws_instance.backend_a
  ]

  provisioner "local-exec" {


    command = "open http://${aws_instance.proxy.public_dns}"

    on_failure = continue
  }
}