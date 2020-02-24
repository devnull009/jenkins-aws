provider "aws" {
  region  = "eu-central-1"
  profile = "default"
  version = "2.50"
}

resource "aws_vpc" "core" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "VPC Core"
  }
}

resource "aws_internet_gateway" "core" {
  vpc_id = aws_vpc.core.id
}

resource "aws_subnet" "core" {
  vpc_id            = aws_vpc.core.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_route_table" "core" {
  vpc_id = aws_vpc.core.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.core.id
  }
}

resource "aws_route_table_association" "core" {
  subnet_id      = aws_subnet.core.id
  route_table_id = aws_route_table.core.id
}

resource "aws_network_acl" "core" {
  vpc_id = aws_vpc.core.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "Jenkins ACL - Access Control List"
  }
}

resource "aws_security_group" "core" {
  name        = "Jenkins Security Group"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.core.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins Core Security Group"
  }
}

resource "aws_eip" "jenkins_master" {
  instance   = aws_instance.master.id
  vpc        = true
  depends_on = [aws_internet_gateway.core]
  tags = {
    Name = "Jenkins Master Elastic IP"
  }
}

resource "aws_eip" "jenkins_slave1" {
  instance   = aws_instance.slave1.id
  vpc        = true
  depends_on = [aws_internet_gateway.core]
  tags = {
    Name = "Jenkins Slave1 Elastic IP"
  }
}

resource "aws_eip" "jenkins_slave2" {
  instance   = aws_instance.slave2.id
  vpc        = true
  depends_on = [aws_internet_gateway.core]
  tags = {
    Name = "Jenkins Slave2 Elastic IP"
  }
}

resource "aws_eip" "jenkins_slave3" {
  instance   = aws_instance.slave3.id
  vpc        = true
  depends_on = [aws_internet_gateway.core]
  tags = {
    Name = "Jenkins Slave3 Elastic IP"
  }
}

resource "aws_eip" "jenkins_slave4" {
  instance   = aws_instance.slave4.id
  vpc        = true
  depends_on = [aws_internet_gateway.core]
  tags = {
    Name = "Jenkins Slave4 Elastic IP"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical id
}

resource "aws_instance" "master" {
  ami                    = data.aws_ami.ubuntu.id
  availability_zone      = "eu-central-1a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.core.id]
  subnet_id              = aws_subnet.core.id
  key_name               = "Kristiyan"

  tags = {
    Name = "Jenkins Master"
  }
}

resource "aws_instance" "slave1" {
  ami                    = data.aws_ami.ubuntu.id
  availability_zone      = "eu-central-1a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.core.id]
  subnet_id              = aws_subnet.core.id
  key_name               = "Kristiyan"

  tags = {
    Name = "Jenkins Slave1"
  }
}

resource "aws_instance" "slave2" {
  ami                    = data.aws_ami.ubuntu.id
  availability_zone      = "eu-central-1a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.core.id]
  subnet_id              = aws_subnet.core.id
  key_name               = "Kristiyan"

  tags = {
    Name = "Jenkins Slave2"
  }
}

resource "aws_instance" "slave3" {
  ami                    = data.aws_ami.ubuntu.id
  availability_zone      = "eu-central-1a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.core.id]
  subnet_id              = aws_subnet.core.id
  key_name               = "Kristiyan"

  tags = {
    Name = "Jenkins Slave3"
  }
}

resource "aws_instance" "slave4" {
  ami                    = data.aws_ami.ubuntu.id
  availability_zone      = "eu-central-1a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.core.id]
  subnet_id              = aws_subnet.core.id
  key_name               = "Kristiyan"

  tags = {
    Name = "Jenkins Slave4"
  }
}

output "Public_IPs" {
  value = "Master: ${aws_eip.jenkins_master.public_ip} Slaves: ${aws_eip.jenkins_slave1.public_ip}, ${aws_eip.jenkins_slave2.public_ip}, ${aws_eip.jenkins_slave3.public_ip}, ${aws_eip.jenkins_slave4.public_ip}"
}

output "Private_IPs" {
  value = "Master: ${aws_eip.jenkins_master.private_ip} Slaves: ${aws_eip.jenkins_slave1.private_ip}, ${aws_eip.jenkins_slave2.private_ip}, ${aws_eip.jenkins_slave3.private_ip}, ${aws_eip.jenkins_slave4.private_ip}"
}
