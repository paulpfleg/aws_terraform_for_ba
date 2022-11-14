
resource "aws_instance" "proxy" {
  ami                    = local.ami
  instance_type          = local.frontend_size
  key_name               = aws_key_pair.local_acess.key_name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.aws-vm-sg.id]
  source_dest_check      = false

  private_ip = local.proxy_private_ip

  //user_data = "./config/frontend.sh"

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }

  connection {
    type        = "ssh"
    host        = aws_instance.proxy.public_ip
    user        = "ubuntu"
    private_key = file("${var.private_key}")
  }

  provisioner "file" {
    source      = "./config/proxy/nginx.conf"
    destination = "./nginx.conf"
  }

  provisioner "remote-exec" {
    script = "./config/proxy/proxy.sh"
  }


  tags = {
    Name = "proxy"
  }

}
/* 
resource "null_resource" "provis_1_proxy" {
  depends_on = [
    aws_instance.proxy
    ]

    connection {
    type        = "ssh"
    host        = aws_instance.proxy.public_ip
    user        = "ubuntu"
    private_key = file("${var.private_key}")
    }

    provisioner "remote-exec" {
    inline = [
      "sed -i 's/REPLACE1/${var.access_key}/g' rev_prox.conf",
      "sudo mv /home/ubuntu/rev_prox.conf /lib/systemd/system",
      "sudo systemctl daemon-reload",
      "sudo systemctl start node.service",
      "sudo systemtl enable node.service"
    ]
  }
}

resource "null_resource" "provis_2_proxy" {
  depends_on = [
    aws_instance.proxy
    ]

    connection {
    type        = "ssh"
    host        = aws_instance.proxy.public_ip
    user        = "ubuntu"
    private_key = file("${var.private_key}")
    }


} */