terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
  shared_credentials_file = "/root/.aws/credentials"
}

module "key-pair" {
  source  = "cloudposse/key-pair/aws"
  version = "0.18.2"
  # insert the 14 required variables here
  generate_ssh_key = "true"
  name = "awskey"
  ssh_public_key_path = "/root/.ssh/"
  environment = "eu-west-3"
}

resource "local_file" "rsa_key" {
    content = "private_key"
    filename = "/root/.ssh/rsa_key"
}

