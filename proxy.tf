
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
    source      = "./config/proxy/files"
    destination = "./files"
  }

  provisioner "remote-exec" {
    script = "./config/proxy/proxy.sh"

    on_failure = continue
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rsync -a -r ubuntu@${aws_instance.proxy.public_ip}:/home/ubuntu/uptime_kuma/uptime-kuma-data config/proxy/files/"
  }

  tags = {
    Name = "proxy"
  }

}
