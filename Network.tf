resource "aws_vpc" "main" {
  cidr_block       = "19.6.0.0/16"

  tags = {
    Name = "Dono_test_vpc"
  }
}

# resource "aws_subnet" "PublicSubnet" {
#     vpc_id = aws_vpc.main.id
#     cidr_block = "19.6.1.0/32"
#     tags = {
#       "name" = "Public Subnet"
#     }
#     availability_zone = {"eu-west-1a", "eu-west-1b", "eu-west-1c"}
# }

# resource "aws_subnet" "PrivateSubnet" {
#     vpc_id = aws_vpc.main.id
#     cidr_block = "19.6.2.0/32"
#     tags = {
#       "name" = "Private Subnet"
#     }
#     availability_zone = {"eu-west-1a", "eu-west-1b", "eu-west-1c"}
# }