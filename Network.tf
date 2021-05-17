resource "aws_vpc" "main" {
  cidr_block       = "19.6.0.0/16"

  tags = {
    Name = "Dono_test_vpc"
  }
}