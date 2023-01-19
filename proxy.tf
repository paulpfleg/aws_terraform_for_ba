# creates the proxy server


resource "aws_instance" "proxy" {
  depends_on = [
    null_resource.configure_file
  ]

  ami                    = local.ami
  instance_type          = local.frontend_size
  key_name               = aws_key_pair.local_acess.key_name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.sg_public_subnets.id]
  source_dest_check      = false

  private_ip = local.proxy_private_ip

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }


  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${var.private_key}")
  }

# uploads config files for nginx and haproxy
  provisioner "file" {
    source      = "./config/proxy/files"
    destination = "./files"
  }

#runs script to install apps, pull repo and start services
  provisioner "remote-exec" {
    script = "./config/proxy/proxy.sh"

  }

  tags = {
    Name = "proxy"
  }
}
