
# --- Instances ---

resource "aws_instance" "frontend" {

  depends_on = [
    aws_instance.proxy
  ]

  count           = var.num_frontend
  ami             = local.ami
  instance_type   = local.frontend_size
  key_name        = aws_key_pair.local_acess.key_name
  subnet_id       = aws_subnet.frontend_subnet.id
  security_groups = [aws_security_group.aws-vm-sg.id]

  private_ip                  = local.frontend_first_ip
  associate_public_ip_address = true

  #source_dest_check      = false

  root_block_device {
    volume_size           = local.frontend_volume_size
    delete_on_termination = true
  }

  tags = {
    Name = "frontend"
  }

}

resource "null_resource" "provis_1_frontend" {
  count = var.provis_frontend ? 1 : 0

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.frontend[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "file" {
    source      = "./config/node.service"
    destination = "/home/ubuntu/node.service"
  }

  provisioner "remote-exec" {
    script = "./config/frontend.sh"
  }

}

resource "null_resource" "provis_2_frontend" {
  count = var.provis_frontend ? 1 : 0
  depends_on = [
    null_resource.provis_1_frontend
  ]

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = aws_instance.frontend[count.index].private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/REPLACE1/${var.access_key}/g' node.service",
      "sed -i 's/REPLACE2/${var.secret_key}/g' node.service",
      "sed -i 's/REPLACE3/${aws_instance.proxy.private_ip}/g' node.service",
      "sudo mv /home/ubuntu/node.service /lib/systemd/system",
      "sudo systemctl daemon-reload",
      "sudo systemctl start node.service",
      "sudo systemctl enable node.service"
    ]
  }
}




