# --- Network ---

# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = local.default_vpc_cidr
  enable_dns_hostnames = true
}
# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.public_subnet_cidr
  availability_zone = local.frontend_subnet_az
}


# Define the public subnet
resource "aws_subnet" "frontend_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.frontend_subnet_cidr
  availability_zone = local.frontend_subnet_az
}
resource "aws_subnet" "backend-subnet-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.backend_subnet_cidr_a
  availability_zone = local.backend_subnet_az_a
}

resource "aws_subnet" "backend-subnet-b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.backend_subnet_cidr_b
  availability_zone = local.backend_subnet_az_b
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}
# forwards all traffic to the pub. internet
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

resource "aws_route_table_association" "frontend-rt-association" {
  subnet_id      = aws_subnet.frontend_subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "backend-a-rt-association" {
  subnet_id      = aws_subnet.backend-subnet-a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "backend-b-rt-association" {
  subnet_id      = aws_subnet.backend-subnet-b.id
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
    Name = "public"
  }
}

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
    Name = "public"
  }
}