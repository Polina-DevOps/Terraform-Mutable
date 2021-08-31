resource "aws_elasticache_cluster" "redis" {
  cluster_id                  = "redis-${var.ENV}"
  engine                      = "redis"
  node_type                   = "cache.t3.micro"
  num_cache_nodes             = 1
  parameter_group_name        = "default.redis6.2"
  engine_version              = "6.x"
  port                        = 6379
  subnet_group_name           = aws_elasticache_subnet_group.redis.name
  security_group_ids          = [aws_security_group.allow_redis.id]
}

resource "aws_elasticache_subnet_group" "redis" {
  name                        = "redis-${var.ENV}"
  subnet_ids                  = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS
  tags                        = {
    Name                      = "redis-${var.ENV}-subnet-group"
  }
}

## AWS Service Group Creation

resource "aws_security_group" "allow_redis" {
  name                        = "allow_redis"
  description                 = "Allow TCP inbound traffic"
  vpc_id                      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress                     {
    description               = "REDIS"
    from_port                 = 6379
    to_port                   = 6379
    protocol                  = "tcp"
    cidr_blocks               = [data.terraform_remote_state.vpc.outputs.VPC_PRIVATEIP_CIDR,data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  }

  tags                        = {
    Name                      = "allow_redis_${var.ENV}"
    Environment               = var.ENV
  }
}


resource "aws_route53_record" "redis" {
  zone_id                     = data.terraform_remote_state.vpc.outputs.INTERNAL_DNS_ZONE_ID
  name                        = "redis-${var.ENV}.roboshop.internal"
  type                        = "CNAME"
  ttl                         = "300"
  records                     = [aws_elasticache_cluster.redis.cache_nodes[0].address]
}
