resource "aws_db_instance" "mysql" {
  allocated_storage             = 10
  engine                        = "mysql"
  engine_version                = "5.7"
  instance_class                = "db.t3.micro"
  name                          = "terraformdefault"
  username                      = "admin"
  password                      = "RoboShop123"
  parameter_group_name          = aws_db_parameter_group.mysql.name
  db_subnet_group_name          = aws_db_subnet_group.mysql.name
  skip_final_snapshot           = true
  identifier                    = "mysql-${var.ENV}"
  vpc_security_group_ids        = [aws_security_group.allow_MySQL.id]
}


resource "aws_db_parameter_group" "mysql" {
  name                          = "rds-pg-${var.ENV}-mysql"
  family                        = "mysql5.7"
}

resource "aws_db_subnet_group" "mysql" {
  name                          = "mysql-${var.ENV}-subnet-group"
  subnet_ids                    = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS

  tags                          = {
    Name                        = "mysql-${var.ENV}-subnet-group"
  }
}

## AWS Service Group Creation

resource "aws_security_group" "allow_MySQL" {
  name                          = "allow_MySQL"
  description                   = "Allow TCP inbound traffic"
  vpc_id                        = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress                       {
    description                 = "MySQL"
    from_port                   = 3306
    to_port                     = 3306
    protocol                    = "tcp"
    cidr_blocks                 = [data.terraform_remote_state.vpc.outputs.VPC_PRIVATEIP_CIDR,data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

  egress {
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    cidr_blocks                 = ["0.0.0.0/0"]
  }

  tags                          = {
    Name                        = "allow_mysqldb_${var.ENV}"
    Environment                 = var.ENV
  }
}

resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = <<EOC
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
cd /tmp
unzip -o mysql.zip
cd mysql-main
mysql -h ${aws_db_instance.mysql.address} -uadmin -pRoboShop123 <shipping.sql
EOC
  }
}

resource "aws_route53_record" "mysql" {
  zone_id                     = data.terraform_remote_state.vpc.outputs.INTERNAL_DNS_ZONE_ID
  name                        = "mysql-${var.ENV}.roboshop.internal"
  type                        = "A"
  ttl                         = "300"
  records                     = [aws_db_instance.mysql.address]
}
