terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "instance_1" { 
  ami = "ami-002843b0a9e09324a" // Ubuntu 20.04 LTS x64 ap-southeast-1
  instance_type = "t2.micro"
}