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
  frontend_subnet_az   = "eu-central-1a"
}

