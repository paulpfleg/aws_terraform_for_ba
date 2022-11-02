resource "aws_key_pair" "frontend" {
  key_name   = "local key"
  public_key = file("${var.public_key}")

  tags = {
    Name = "frontend"
  }
}

# --- Instances ---

resource "aws_instance" "app_server" {
  ami                    = local.ami
  instance_type          = local.frontend_size
  key_name               = aws_key_pair.frontend.key_name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.aws-vm-sg.id]
  source_dest_check      = false

  user_data = "./config/frontend.sh"

  associate_public_ip_address = true

  root_block_device {
    volume_size           = local.frontend_volume_size
    delete_on_termination = true
  }

    connection {
    type = "ssh"
    host = aws_instance.app_server.public_ip
    user = "ubuntu"
    private_key = file("${var.private_key}")
    }

    provisioner "remote-exec" {
    inline = [
      "hostname 'frontend'",
      "echo 'frontend' > /etc/hostname",
      "AWSAccessKeyId=${var.access_key}",
      "AWSSecretKey=${var.secret_key}",
      "export AWSAcessKeyId",
      "export AWSSecretKey"
    ]    
    } 


  tags = {
    Name = "frontend"
  }

}

resource "null_resource" "provis_frontend" {
  depends_on = [
    aws_instance.app_server
  ]

  connection {
    type = "ssh"
    host = aws_instance.app_server.public_ip
    user = "ubuntu"
    private_key = file("${var.private_key}")
  }

  provisioner "remote-exec" {
    script = "./config/frontend.sh"    
  }  
}

resource "null_resource" "start_node" {
  depends_on = [
    null_resource.provis_frontend
  ]

  connection {
    type = "ssh"
    host = aws_instance.app_server.public_ip
    user = "ubuntu"
    private_key = file("${var.private_key}")
  }

  provisioner "remote-exec" {
  
    inline = [
      "npm install",
      "AWSAccessKeyId=${var.access_key} AWSSecretKey=${var.public_key} node ."
    ]       
  }  
}


# --- Network ---

# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = local.default_vpc_cidr
  enable_dns_hostnames = true
}
# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.frontend_subnet_cidr
  availability_zone = local.frontend_subnet_az
}
# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}
# Define the public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
# Assign the public route table to the public subnet
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

# Define the security group for the EC2 Instance
resource "aws_security_group" "aws-vm-sg" {
  name        = "vm-sg"
  description = "Allow incoming connections"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

    ingress {
    from_port   = 8080
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "frontend"
  }
}

# --- Output ---

output "ec2_global_ips" {
  value = aws_instance.app_server.public_ip

}