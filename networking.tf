#Creation of a new VPC
resource "aws_vpc" "secondary" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Secondary-VPC"
  }
}

/*resource "aws_internet_gateway_attachment" "example" {
  internet_gateway_id = aws_internet_gateway.secondary.id
  vpc_id              = aws_vpc.secondary.id
}*/

#Creation of IGW for Secondary VPC
resource "aws_internet_gateway" "secondary" {
  vpc_id = aws_vpc.secondary.id

  tags = {
    Name = "Secondary-IGW"
  }
}

#Creationn of S3 Gateway to avoid public access of S3 for security reasons
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.secondary.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.secondary.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_subnet" "secondary" {
  vpc_id     = aws_vpc.secondary.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "Secondary_Public_Subnet"
  }
}

resource "aws_route_table" "secondary" {
  vpc_id = aws_vpc.secondary.id

  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary.id
  }

  tags = {
    Name = "genomics_test"
  }
}

resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.secondary.id
    route_table_id = aws_route_table.secondary.id
}

 
