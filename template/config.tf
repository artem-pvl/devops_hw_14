terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "3.63.0"
        }
    }
}

provider "aws" {
  region = "eu-west-3"
  shared_credentials_file = "/root/.aws/credentials"
}

resource "aws_instance" "newserv" {
  ami = "ami-0f7cd40eac2214b37"
  instance_type = "t2.micro"
}