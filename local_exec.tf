#executes commans on local machine


# enables / configures ssh-agent
resource "null_resource" "provis_local" {
  depends_on = [
    aws_instance.proxy
  ]

  provisioner "local-exec" {
    command = "sed -i 'ig' 's/IP_PROXY/${aws_instance.proxy.public_ip}/g' ./config/local/conf"

    on_failure = continue
  }

  provisioner "local-exec" {
    command = "mv ./config/local/config ~/.ssh/config; ssh-agent -s; ssh-add ${var.private_key}"

    on_failure = continue
  }

}

#hands over variables to shell scripts
resource "null_resource" "configure_file" {
  provisioner "local-exec" {
    command = "bash ${templatefile("${path.module}/conf_nginx.sh", { num_backend_a = local.num_backend_a, num_backend_b = local.num_backend_b, num_backend = var.num_backend })}"

    on_failure = fail
  }
}