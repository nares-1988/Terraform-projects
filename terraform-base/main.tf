provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "terra-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terra-vpc"
  }
}

resource "aws_internet_gateway" "igw-terra" {
  vpc_id = aws_vpc.terra-vpc.id

  tags = {
    Name = "igw-terra"
  }
}

resource "aws_subnet" "tf-public-sub" {
  vpc_id     = aws_vpc.terra-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "tf-public-sub"
  }
}

resource "aws_route_table" "RT-terra" {
  vpc_id = aws_vpc.terra-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-terra.id
  }

  tags = {
    Name = "RT-terra"
  }
}

resource "aws_route_table_association" "rt-associate-pub" {
  subnet_id      = aws_subnet.tf-public-sub.id
  route_table_id = aws_route_table.RT-terra.id
}

resource "aws_security_group" "terra-sg" {
  name        = "terra-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.terra-vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "terra-sg"
  }
}
