resource "aws_key_pair" "local_acess" {
  key_name   = "local key"
  public_key = file("${var.public_key}")

  tags = {
    Name = "frontend"
  }
}