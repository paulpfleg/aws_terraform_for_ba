
# --- Instances ---

resource "aws_instance" "backend" {

  depends_on = [
    aws_instance.proxy
  ]

  count                       = var.num_backend
  ami                         = local.ami
  instance_type               = local.backend_size
  key_name                    = aws_key_pair.local_acess.key_name
  subnet_id                   = aws_subnet.public-subnet.id
  security_groups             = [aws_security_group.aws-vm-sg.id]
  private_ip                  = local.backend_first_ip
  associate_public_ip_address = true

  root_block_device {
    volume_size           = local.backend_volume_size
    delete_on_termination = true
  }

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.backend[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname backend"
    ]
  }


  tags = {
    Name = "backend"
  }
}

/* resource "aws_network_interface" "backend" {
  count           = var.num_backend > 0 ? 1 : 0
  subnet_id       = aws_subnet.public-subnet.id
  private_ips     = [local.backend_first_ip]
  security_groups = [aws_security_group.aws-vm-sg.id]
}
 */
resource "null_resource" "provis_backend" {
  count = var.num_backend > 0 ? 1 : 0
  depends_on = [
    aws_instance.backend
  ]

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.backend[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "remote-exec" {
    script = "./config/backend.sh"
  }
}

resource "null_resource" "start_node_backend" {
  count = var.num_backend > 0 ? 1 : 0
  depends_on = [
    null_resource.provis_backend
  ]

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.backend[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "file" {
    source      = "./config/node_backend.service"
    destination = "/home/ubuntu/node.service"
  }

  provisioner "remote-exec" {

    inline = [
      "sed -i 's/REPLACE1/${var.access_key}/g' node.service",
      "sed -i 's/REPLACE2/${var.secret_key}/g' node.service",
      "sudo mv /home/ubuntu/node.service /lib/systemd/system",
      "sudo systemctl daemon-reload",
      "sudo systemctl start node.service"
    ]
  }
}


