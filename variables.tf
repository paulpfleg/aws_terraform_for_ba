variable "access_key" {
  description = "the acess key"
  type        = string
  default     = ""
}

variable "secret_key" {
  description = "the aws secret key"
  type        = string
  default     = ""
}

variable "public_key" {
  description = "the ssh public key"
  type        = string
  default     = ""
}

variable "private_key" {
  description = "the ssh public key"
  type        = string
  default     = ""
}

variable "num_frontend" {
  description = "number of frontend nodes"
  type        = number
  default     = 1
}

variable "provis_frontend" {
  description = "should the frontend be provisioned?"
  type        = bool
  default     = true
}

variable "num_backend" {
  description = "number of backend nodes"
  type        = number
  default     = 1
}




locals {

  # --- Instances FE ---
  frontend_size        = "t2.micro"
  ami                  = "ami-0caef02b518350c8b"
  frontend_volume_size = 8

  # --- Instances BE ---
  backend_size        = "t2.micro"
  backend_volume_size = 50

  # --- Netzwork ---
  default_vpc_cidr     = "192.168.0.0/16"
  frontend_subnet_cidr = "192.168.1.0/24"
  backend_subnet_cidr_a  = "192.168.2.0/24"
  backend_subnet_cidr_b  = "192.168.3.0/24"
  frontend_subnet_az   = "eu-central-1a"
  backend_subnet_az_a    = "eu-central-1b"
  backend_subnet_az_b    = "eu-central-1c"

  cloud_config_config = <<-END
    #cloud-config
    ${jsonencode({
  write_files = [
    {
      path        = "/etc/example.txt"
      permissions = "0644"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64("${path.module}/config/node.service")
    },
  ]
})}
  END

frontend_first_ip        = "192.168.1.8"
loadbalancer_frontend_ip = "192.168.1.9"
loadbalancer_backend_ip  = "192.168.2.8"
backend_first_ip_a         = "192.168.2.9"
backend_first_ip_b         = "192.168.3.9"
}

