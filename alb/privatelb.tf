resource "aws_lb" "private_lb" {
  name                                  = "roboshop-${var.ENV}-internal_lb"
  internal                              = true
  load_balancer_type                    = "application"
  security_groups                       = [aws_security_group.allow_lb_internal]
  subnets                               = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS

  enable_deletion_protection            = false

  tags                                  = {
    Name                                = "roboshop-${var.ENV}-internal"
    Environment                         = var.ENV
  }
}

resource "aws_security_group" "allow_lb_internal" {
  name                                  = "allow_lb_internal_${var.ENV}"
  description                           = "allow_lb_internal_${var.ENV}"
  vpc_id                                = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description                         = "HTTP"
    from_port                           = 80
    to_port                             = 80
    protocol                            = "tcp"
    cidr_blocks                         = [data.terraform_remote_state.vpc.outputs.VPC_PRIVATE_CIDR]
  }

  egress {
    from_port                           = 0
    to_port                             = 0
    protocol                            = "-1"
    cidr_blocks                         = ["0.0.0.0/0"]
  }

  tags                                  = {
    Name                                = "allow_lb_internal_${var.ENV}"
    Environment                         = var.ENV
  }
}
