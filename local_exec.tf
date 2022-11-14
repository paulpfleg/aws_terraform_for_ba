resource "null_resource" "provis_local" {
  depends_on = [
    aws_instance.proxy
  ]

  provisioner "local-exec" {
    command = "touch ~/.ssh/config && sed -i 'ig' 's/IP_PROXY/${aws_instance.proxy.public_ip}/g' ./config/local/conf && mv ./config/local/config ~/.ssh/config"
  }
}