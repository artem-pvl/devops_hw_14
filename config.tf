terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
  shared_credentials_file = "/root/.aws/credentials"

}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "foo" {
    content     = tls_private_key.example.private_key_pem
    filename = "/root/.ssh/id_rsa"
}

resource "aws_key_pair" "aws_key_t" {
  key_name   = "aws_key_t"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all"

  ingress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  tags = {
    Name = "allow_all"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0f7cd40eac2214b37"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = "web"
  }
}

resource "aws_instance" "build" {
  ami                    = "ami-0f7cd40eac2214b37"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  key_name      = aws_key_pair.aws_key_t.key_name

  tags = {
    Name = "build"
  }
}

# module "key-pair" {
#   source  = "cloudposse/key-pair/aws"
#   version = "0.18.2"
#   # insert the 14 required variables here
#   generate_ssh_key = "true"
#   name = "awskey"
#   ssh_public_key_path = "/root/.ssh/"
#   environment = "eu-west-3"
# }

# resource "local_file" "rsa_key" {
#     content = "private_key"
#     filename = "/root/.ssh/rsa_key"
# }

