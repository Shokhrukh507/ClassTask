# Creatae VPC for this project
resource "aws_vpc" "vpcForProject" {
  cidr_block = "10.0.0.0/16"
}
data "aws_availability_zones" "available" {
  
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpcForProject.id
  count = var.az_count
  cidr_block = cidrsubnet(aws_vpc.vpcForProject.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpcForProject.id
  count = var.az_count
  cidr_block = cidrsubnet(aws_vpc.vpcForProject.cidr_block, 8, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "igw_project" {
  vpc_id = aws_vpc.vpcForProject.id
}
resource "aws_route" "internet_access" {
  gateway_id = aws_internet_gateway.igw_project.id
  route_table_id = aws_vpc.vpcForProject.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_eip" "eip" {
  count = var.az_count
  vpc = true
  depends_on = [ aws_internet_gateway.igw_project ]
}
resource "aws_nat_gateway" "NAT_Gateway" {
  count = var.az_count
  subnet_id = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
}
resource "aws_route_table" "private" {
  count = var.az_count
  vpc_id = aws_vpc.vpcForProject.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.NAT_Gateway.*.id, count.index)
  }
}
resource "aws_route_table_association" "private" {
  count = var.az_count
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}