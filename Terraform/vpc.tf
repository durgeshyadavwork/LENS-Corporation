resource "aws_vpc" "cicd_vpc" {
    cidr_block = "192.168.0.0/24"
    tags ={
        name="CI/CD VPC"
    }

}

resource "aws_subnet" "cicd_public_subnet" {
    vpc_id = aws_vpc.cicd_vpc.id
    cidr_block = "192.168.0.0/28"
    availability_zone="ap-south-1a"
    tags ={

    name="CI/CD Public Subnet"
    }
  
}

resource "aws_subnet" "cicd_public_subnet2" {
    vpc_id = aws_vpc.cicd_vpc.id
    cidr_block = "192.168.0.16/28"
    availability_zone="ap-south-1b"
    tags ={

    name="CI/CD Public Subnet2"
    }
  
}

resource "aws_subnet" "cicd_private_subnet" {
  vpc_id = aws_vpc.cicd_vpc.id
  cidr_block = "192.168.0.32/28"
  availability_zone="ap-south-1a"
  tags = {
    name="CD/CD Private Subnet"
  }
}

resource "aws_subnet" "cicd_private_subnet2" {
  vpc_id = aws_vpc.cicd_vpc.id
  cidr_block = "192.168.0.48/28"
  availability_zone="ap-south-1b"
  tags = {
    name="CD/CD Private Subnet2"
  }
}




resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.cicd_vpc.id
    tags = {
      name="Internet Gateway"
    }
  
}

resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.cicd_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
    }
    tags = {
      name="public route table"
    }
  
}

resource "aws_route_table_association" "route_table_public_association" {
    subnet_id = aws_subnet.cicd_public_subnet.id
    route_table_id = aws_route_table.public_route.id
    
  
}

resource "aws_route_table_association" "public_table_association2" {
    subnet_id = aws_subnet.cicd_public_subnet2.id
    route_table_id = aws_route_table.public_route.id
  
}


