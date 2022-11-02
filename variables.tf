variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "public_key" {
  type = string
}

locals {

# --- Instances ---
  frontend_size = "t2.micro"
  ami           = "ami-0caef02b518350c8b"

# --- Netzwork ---
  default_vpc_cidr  = "192.168.0.0/16"
  frontend_subnet_cidr = "192.168.1.0/24"
  frontend_subnet_az = "eu-central-1a"
}

