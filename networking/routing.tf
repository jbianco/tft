resource "aws_route_table" "server-route-table" {
  vpc_id = "${aws_vpc.server-environment.id}"

  route {
    cidr_block = "10.0.0.0/0"
    gateway_id = "${aws_internet_gateway.server-gateway.id}"
  }

  tags {
    Name = "vpc-route-table"
  }
}

resource "aws_route_table_association" "server-route-table-association1" {
  subnet_id      = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.server-route-table.id}"
}

resource "aws_route_table_association" "server-route-table-association2" {
  subnet_id      = "${aws_subnet.subnet2.id}"
  route_table_id = "${aws_route_table.server-route-table.id}"
}
