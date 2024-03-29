# --- variables for use in other files ---

# --- keys for cloud provider acess ---

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

# --- ssh keys ---

variable "public_key" {
  description = "the ssh public key"
  type        = string
  default     = ""
}

variable "private_key" {
  description = "the ssh private key"
  type        = string
  default     = ""
}

# --- front / backend characteristics

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
}

locals {

  # --- Instances FE ---
  frontend_size = "t2.micro"
  ami           = "ami-0caef02b518350c8b" 

  frontend_volume_size = 8

  # --- Instances BE ---
  backend_size        = "c6g.large"

    ami_backend   = "ami-05d8c3dc27d413c4b" 

  #"ami-05d8c3dc27d413c4b" #arm eu-central ubuntu 22.04 
  #"ami-0caef02b518350c8b" #x84 eu-central ubuntu 22.04

  # --- size of backends "Hard Drive"
  backend_volume_size = 50

  # --- calculates the number of nodes in AVZ A/B out of total Backend nodes
  num_backend_a       = ceil(var.num_backend / 2)
  num_backend_b       = floor(var.num_backend / 2)


  # --- Netzwork ---

  #--- CIDRs of VPC and its Subnets ---
  default_vpc_cidr = "192.168.0.0/16"

  public_subnet_cidr    = "192.168.1.0/24"
  frontend_subnet_cidr  = "192.168.2.0/24"
  backend_subnet_cidr_a = "192.168.3.0/24"
  backend_subnet_cidr_b = "192.168.4.0/24"


  # --- (first) IP adresses of subnets
  proxy_private_ip   = "192.168.1.16"
  frontend_first_ip  = "192.168.2.16"
  backend_first_ip_a = "192.168.3.16"
  backend_first_ip_b = "192.168.4.16"

  # --- specify regions, the servers are deployed to
  frontend_subnet_az  = "eu-central-1a"
  backend_subnet_az_a = "eu-central-1a"
  backend_subnet_az_b = "eu-central-1b"



}

