
# --- Instances ---


# Instance A
resource "aws_instance" "backend_a" {

  depends_on = [
    aws_instance.proxy
  ]

  count                       = var.num_backend_a
  ami                         = local.ami
  instance_type               = local.backend_size
  key_name                    = aws_key_pair.local_acess.key_name
  subnet_id                   = aws_subnet.backend-subnet-a.id
  security_groups             = [aws_security_group.aws-vm-sg.id]
  private_ip                  = local.backend_first_ip_a
  associate_public_ip_address = true

  root_block_device {
    volume_size           = local.backend_volume_size
    delete_on_termination = true
  }

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.backend_a[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "file" {
    source      = "./config/node_backend.service"
    destination = "/home/ubuntu/node_backend.service"
  }

  tags = {
    Name = "backend"
  }
}

resource "null_resource" "provis_1_backend_a" {
  count = var.num_backend_a > 0 ? 1 : 0
  depends_on = [
    aws_instance.backend_a
  ]

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.backend_a[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "remote-exec" {
    script     = "./config/backend.sh"
    on_failure = continue
  }

}


resource "null_resource" "provis_2_backend_a" {
  count = var.num_backend_a > 0 ? 1 : 0
  depends_on = [
    null_resource.provis_1_backend_a
  ]

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.backend_a[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/REPLACE1/${var.access_key}/g' node_backend.service",
      "sed -i 's/REPLACE2/${var.secret_key}/g' node_backend.service",
      "sudo mv /home/ubuntu/node_backend.service /lib/systemd/system",
      "sudo systemctl daemon-reload",
      "sudo systemctl start node_backend.service"
    ]
  }
}

# Instance B

resource "aws_instance" "backend_b" {

  depends_on = [
    aws_instance.proxy
  ]

  count                       = var.num_backend_b
  ami                         = local.ami
  instance_type               = local.backend_size
  key_name                    = aws_key_pair.local_acess.key_name
  subnet_id                   = aws_subnet.backend-subnet-b.id
  security_groups             = [aws_security_group.aws-vm-sg.id]
  private_ip                  = local.backend_first_ip_b
  associate_public_ip_address = true

  root_block_device {
    volume_size           = local.backend_volume_size
    delete_on_termination = true
  }

  tags = {
    Name = "backend"
  }
}


resource "null_resource" "provis_1_backend_b" {
  count = var.num_backend_b > 0 ? 1 : 0
  depends_on = [
    aws_instance.backend_b
  ]

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.backend_b[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "remote-exec" {
    script     = "./config/backend.sh"
    on_failure = continue
  }

}


resource "null_resource" "provis_2_backend_b" {
  count = var.num_backend_b > 0 ? 1 : 0
  depends_on = [
    null_resource.provis_1_backend_b
  ]

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.backend_b[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/REPLACE1/${var.access_key}/g' node_backend.service",
      "sed -i 's/REPLACE2/${var.secret_key}/g' node_backend.service",
      "sudo mv /home/ubuntu/node_backend.service /lib/systemd/system",
      "sudo systemctl daemon-reload",
      "sudo systemctl start node_backend.service"
    ]
  }
}