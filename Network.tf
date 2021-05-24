resource "aws_vpc" "main" {
  cidr_block       = "19.6.0.0/16"

  tags = {
    Name = "Dono_test_vpc"
  }
}

resource "aws_subnet" "PublicSubnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "${var.PublicSubnet}"
    tags = {
      "name" = "Public Subnet"
    }
    availability_zone = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

resource "aws_subnet" "PrivateSubnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "${var.PrivateSubnet}"
    tags = {
      "name" = "Private Subnet"
    }
    availability_zone = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

resource "aws_route_table_association" "PublicSubnet" {
    subnet_id = "${aws_subnet.PublicSubnet.id}"
    route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_route_table_association" "PrivateSubnet" {
    subnet_id = "${aws_subnet.PrivateSubnet.id}"
    route_table_id = "${aws_route_table.private_route.id}"
}

resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "Internet Gateway"
    }
}

resource "aws_network_acl" "access_to_all" {
   vpc_id = "${aws_vpc.main.id}"
    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "open to all"
    }
}

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
      Name = "Public Route"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_route_table" "private_route" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
      Name = "Private Route"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}