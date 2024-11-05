data "aws_vpc" "data-vpc" {
  id = "vpc-0b88e0f1a71277295"
}


resource "aws_internet_gateway" "Data-source-igw" {
  vpc_id = data.aws_vpc.data-vpc.id

  tags = {
    Name = "Data-source-igw"
  }
}
