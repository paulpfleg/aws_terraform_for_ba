resource "aws_key_pair" "local_acess" {
  key_name   = "local key"
  public_key = file("${var.public_key}")

  tags = {
    Name = "frontend"
  }
}

# --- Instances ---

resource "aws_instance" "frontend" {
  ami                    = local.ami
  instance_type          = local.frontend_size
  key_name               = aws_key_pair.local_acess.key_name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.aws-vm-sg.id]
  source_dest_check      = false

  //user_data = "./config/frontend.sh"

  associate_public_ip_address = true

  root_block_device {
    volume_size           = local.frontend_volume_size
    delete_on_termination = true
  }

    connection {
    type = "ssh"
    host = aws_instance.frontend.public_ip
    user = "ubuntu"
    private_key = file("${var.private_key}")
    }

    provisioner "file" {
    source      = "./config/node.service"
    destination = "/home/ubuntu/node.service"
    }

    provisioner "remote-exec" {
    script = "./config/frontend.sh"    
    }



  tags = {
    Name = "frontend"
  }

}

resource "null_resource" "provis_frontend" {
  depends_on = [
    aws_instance.frontend
  ]

  connection {
    type = "ssh"
    host = aws_instance.frontend.public_ip
    user = "ubuntu"
    private_key = file("${var.private_key}")
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




