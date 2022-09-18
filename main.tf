provider "aws" {
  region                  = var.AWS_REGION
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = var.availability_zones
  tags = {
    Name = "Default subnet"
  }
}

resource "aws_security_group" "secure" {
  name        = "secure"
  description = "Allow HTTP, SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "k8s"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "k8s-1"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "k8s-2"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "ping"
    from_port   = 0
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Name = "security-wizard"
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "k8_ssh_key" {
    filename = var.key_name
    file_permission = "600"
    content  = tls_private_key.ssh.private_key_pem
}

resource "aws_key_pair" "k8_ssh" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh

}
resource "aws_instance" "master" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name = aws_key_pair.k8_ssh.key_name
  security_groups = [ "${aws_security_group.secure.name}" ]
  tags = {
    Name = "Master"
  }
  root_block_device {
    delete_on_termination = "true"
  }
}

resource "aws_instance" "slave" {
  ami = var.ami_id
  instance_type = "t3.micro"
  key_name = aws_key_pair.k8_ssh.key_name
  security_groups = [ "${aws_security_group.secure.name}" ]
  tags = {
    Name = "Slave"
  }
  root_block_device {
    delete_on_termination = "true"
  }
}
