resource "aws_route53_zone_association" "zone-associate" {
  zone_id       = var.INTERNAL_DNS_ZONE_ID
  vpc_id        = aws_vpc.main.id
}