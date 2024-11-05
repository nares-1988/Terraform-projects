#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "terraform-workspace-practice"
    key    = "function.tfstate"
    region = "us-east-1"
  }
}


resource "aws_vpc" "Practice_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.vpc_name}"
    Owner       = local.Owner
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "Practice_igw" {
  vpc_id = aws_vpc.Practice_vpc.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_subnet" "public-subnet" {
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.Practice_vpc.id
  cidr_block        = element(var.public_cidr_block, count.index + 1)
  availability_zone = element(var.azs, count.index + 1)

  tags = {
    Name        = "${var.vpc_name}-public-subnet-${count.index + 1}"
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = length(var.public_cidr_block)
  vpc_id            = aws_vpc.Practice_vpc.id
  cidr_block        = element(var.private_cidr_block, count.index + 1)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${count.index + 1}"
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"
  }
}


resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.Practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Practice_igw.id
  }

  tags = {
    Name        = "${var.vpc_name}-public-route-table"
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"
  }
}


resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.Practice_vpc.id

  tags = {
    Name        = "${var.vpc_name}-private-route-table"
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"
  }
}



# data "aws_ami" "my_ami" {
#   most_recent = true
#   #name_regex       = "^sai"
#   owners = ["232323232323232323"]
# }


# resource "aws_instance" "web-1" {
#     ami = "${data.aws_ami.my_ami.id}"
#     #ami = "ami-0d857ff0f5fc4e03b"
#     availability_zone = "us-east-1a"
#     instance_type = "t2.micro"
#     key_name = "LaptopKey"
#     subnet_id = "${aws_subnet.subnet1-public.id}"
#     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
#     associate_public_ip_address = true	
#     tags = {
#         Name = "Server-1"
#         Env = "Prod"
#         Owner = "sai"
# 	CostCenter = "ABCD"
#     }
#      user_data = <<- EOF
#      #!/bin/bash
#      	sudo apt-get update
#      	sudo apt-get install -y nginx
#      	echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
#      	sudo systemctl start nginx
#      	sudo systemctl enable nginx
#      EOF

# }

# resource "aws_dynamodb_table" "state_locking" {
#   hash_key = "LockID"
#   name     = "dynamodb-state-locking"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#   billing_mode = "PAY_PER_REQUEST"
# }

##output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
#!/bin/bash
# echo "Listing the files in the repo."
# ls -al
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Packer Now...!!"
# packer build -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Terraform Now...!!"
# terraform init
# terraform apply --var-file terraform.tfvars -var="aws_access_key=AAAAAAAAAAAAAAAAAA" -var="aws_secret_key=BBBBBBBBBBBBB" --auto-approve
