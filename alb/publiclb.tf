resource "aws_lb" "public_lb" {
  name               = "roboshop-${var.ENV}-public_lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = false

  tags = {
    Name                                = "roboshop-${var.ENV}-public"
    Environment                         = var.ENV
  }
}

resource "aws_security_group" "allow_lb_public" {
  name                                  = "allow_lb_public_${var.ENV}"
  description                           = "allow_lb_public_${var.ENV}"
  vpc_id                                = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description                         = "HTTP"
    from_port                           = 80
    to_port                             = 80
    protocol                            = "tcp"
    cidr_blocks                         = ["0.0.0.0/0"]
  }

  egress {
    from_port                           = 0
    to_port                             = 0
    protocol                            = "-1"
    cidr_blocks                         = ["0.0.0.0/0"]
  }

  tags                                  = {
    Name                                = "allow_lb_public_${var.ENV}"
    Environment                         = var.ENV
  }
}