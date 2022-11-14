resource "aws_alb" "backend-loadbalancer" {
  name               = "backend-loadbalancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aws-vm-sg.id]
  subnets = [ aws_subnet.backend-subnet-a.id , aws_subnet.backend-subnet-b.id , aws_subnet.public-subnet.id]

/*   subnet_mapping {
    subnet_id            = aws_subnet.public-subnet.id
    private_ipv4_address = local.loadbalancer_frontend_ip
  }

    subnet_mapping {
    subnet_id            = aws_subnet.backend-subnet.id
    private_ipv4_address = local.loadbalancer_backend_ip
  } */

  //internal = true


}

resource "aws_alb_target_group" "backend" {
  name     = "backend"
  port     = 8081
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.vpc.id
  stickiness {
    type = "lb_cookie"
  }

  health_check {
    path                = "/"
    port                = 8081
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.backend-loadbalancer.arn
  port              = "8081"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.backend.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "to_backend_a_instance" {
  target_group_arn = aws_alb_target_group.backend.arn
  target_id        = aws_instance.backend_a[0].id
  port             = 8081
}

resource "aws_lb_target_group_attachment" "to_backend_b_instance" {
  target_group_arn = aws_alb_target_group.backend.arn
  target_id        = aws_instance.backend_b[0].id
  port             = 8081
}