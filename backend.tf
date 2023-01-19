
# --- Instances ---


# Backend Instance A
resource "aws_instance" "backend_a" {

  depends_on = [
    aws_instance.proxy
  ]

  count                       = local.num_backend_a
  ami                         = local.ami_backend
  instance_type               = local.backend_size
  key_name                    = aws_key_pair.local_acess.key_name
  subnet_id                   = aws_subnet.backend-subnet-a.id
  security_groups             = [aws_security_group.sg_private_subnets.id]
  private_ip                  = "${substr(local.backend_first_ip_a, 0, 10)}${count.index + tonumber(substr(local.proxy_private_ip, -2, 0))}"
  associate_public_ip_address = true

  root_block_device {
    volume_size           = local.backend_volume_size
    delete_on_termination = true
  }

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = self.private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
    agent        = true
  }

# change hostname edit ssh conf. to enable github pull via ssh
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname backend_A_${count.index}",
      "touch ./.ssh/know_hosts",
      "echo'github.com ${var.public_key}' >> ./.ssh/know_hosts",
    ]

    on_failure = continue
  }

# send service files to server
  provisioner "file" {
    source      = "./config/node_backend.service"
    destination = "/home/ubuntu/node_backend.service"
  }

# run shell script to install apps, pull repo, create folder structure
  provisioner "remote-exec" {
    script     = "./config/backend.sh"
    on_failure = continue
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/REPLACE1/${var.access_key}/g' node_backend.service",
      "sed -i 's/REPLACE2/${var.secret_key}/g' node_backend.service",
      "sudo mv /home/ubuntu/node_backend.service /lib/systemd/system",
      "sudo systemctl enable node_backend.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl start node_backend.service"
    ]
  }

  tags = {
    Name = "backend_Az_A_${count.index}"
  }
}


# Instance B

# same as instance A but in other AVZ
resource "aws_instance" "backend_b" {

  depends_on = [
    aws_instance.proxy
  ]

  count                       = local.num_backend_b
  ami                         = local.ami_backend
  instance_type               = local.backend_size
  key_name                    = aws_key_pair.local_acess.key_name
  subnet_id                   = aws_subnet.backend-subnet-b.id
  security_groups             = [aws_security_group.sg_private_subnets.id]
  private_ip                  = "${substr(local.backend_first_ip_b, 0, 10)}${count.index + tonumber(substr(local.proxy_private_ip, -2, 0))}"
  associate_public_ip_address = true

  root_block_device {
    volume_size           = local.backend_volume_size
    delete_on_termination = true
  }

  connection {
    type         = "ssh"
    bastion_host = aws_instance.proxy.public_ip
    host         = self.private_ip
    user         = "ubuntu"
    private_key  = file("${var.private_key}")
    agent        = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname backend_B_${count.index}",
      "touch ./.ssh/know_hosts",
      "echo'github.com ${var.public_key}' >> ./.ssh/know_hosts",
    ]

    on_failure = continue
  }

  provisioner "file" {
    source      = "./config/node_backend.service"
    destination = "/home/ubuntu/node_backend.service"
  }

  provisioner "remote-exec" {
    script     = "./config/backend.sh"
    on_failure = continue
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/REPLACE1/${var.access_key}/g' node_backend.service",
      "sed -i 's/REPLACE2/${var.secret_key}/g' node_backend.service",
      "sudo mv /home/ubuntu/node_backend.service /lib/systemd/system",
      "sudo systemctl enable node_backend.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl start node_backend.service"
    ]
  }

  tags = {
    Name = "backend_Az_B_${count.index}"
  }
}
