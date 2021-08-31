output "VPC_ID" {
  value = aws_vpc.main.id
}

output "VPC_PRIVATE_CIDR" {
  value = var.VPC_PRIVATEIP_CIDR
}

output "VPC_PUBLIC_CIDR" {
  value = var.VPC_PUBLICIP_CIDR
}

output "PRIVATE_SUBNET_CIDRS" {
  value = var.PRIVATE_SUBNET_CIDR
}

output "PUBLIC_SUBNET_CIDRS" {
  value = var.PUBLIC_SUBNET_CIDR
}

output "DEFAULT_VPC_ID" {
  value = var.DEFAULT_VPC_ID
}

output "DEFAULT_VPC_CIDR" {
  value = var.DEFAULT_VPC_CIDR
}

output "PRIVATE_SUBNETS" {
  value = aws_subnet.private.*.id
}

output "PUBLIC_SUBNETS" {
  value = aws_subnet.public.*.id
}

output "INTERNAL_DNS_ZONE_ID" {
  value = var.INTERNAL_DNS_ZONE_ID
}