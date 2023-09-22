resource "aws_vpc" "lotus-lab_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "lotus-lab_subnet" {
  vpc_id = aws_vpc.lotus-lab_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "lotus-lab_sg" {
  name_prefix = "lotus-lab_sg"
  vpc_id = aws_vpc.lotus-lab_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${local.public_ip_data.ip}/32"]
  }

  # ALLOWS INTERNET ACCESS FROM RESOURCES ATTACHED TO THIS SECURITY GROUP
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_internet_gateway" "lotus-lab_igw" {
  vpc_id = aws_vpc.lotus-lab_vpc.id
}

resource "aws_route_table" "lotus-lab_route_table" {
  vpc_id = aws_vpc.lotus-lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lotus-lab_igw.id
  }
}

resource "aws_route_table_association" "lotus-lab_subnet_association" {
  subnet_id = aws_subnet.lotus-lab_subnet.id
  route_table_id = aws_route_table.lotus-lab_route_table.id
}