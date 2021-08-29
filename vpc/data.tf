data "aws_route_table" "default" {
  vpc_id = var.DEFAULT_VPC_ID
}

//output "test" {
//  value = data.aws_route_table.default.route_table_id
//}
