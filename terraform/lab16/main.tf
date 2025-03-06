provider "aws" {
  region = "us-east-1" # غيريها حسب منطقتك
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" # يجب أن يكون مطابقًا لما أنشأتِه يدويًا

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My IGW"
  }
}



resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # السماح بالـ SSH من أي مكان
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # السماح بالـ HTTP من أي مكان
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public SG"
  }
}


resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id] # السماح فقط لـ EC2 بالوصول
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS SG"
  }
}


resource "aws_instance" "web_server" {
  ami                    = "ami-01e3c4a339a264cc9" # غيّريها حسب منطقتكِ
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  security_groups        = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Web Server"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }
}


resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet 2"
  }
}


resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id]  # يجب استخدام شبكتين

  tags = {
    Name = "my-db-subnet-group"
  }
}



resource "aws_db_instance" "my_rds" {
  allocated_storage    = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username           = "admin"
  password           = "password123"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible = false
  multi_az           = false
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name  # استخدام مجموعة الشبكات

  tags = {
    Name = "my-rds"
  }
}







