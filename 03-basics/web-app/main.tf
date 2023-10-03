terraform {
  backend "remote" {
    organization = "thomas-devops-directive"

    workspaces {
      name = "demo-terraform-aws"
    }
  }

  required_providers {
    aws ={
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "instances" {
  name = "instance-security-group"
}

resource "aws_instance" "instance_1" {
    ami = "ami-002843b0a9e09324a" // Ubuntu 20.04 LTS x64 ap-southeast-1
    instance_type = "t2.micro" 
    security_groups =  [aws_security_group.instances.name]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World from Instance 1" > index.html
                python3 -m http.server 8080 &
                EOF
}

resource "aws_instance" "instance_2" {
  ami = "ami-002843b0a9e09324a" // Ubuntu 20.04 LTS x64 ap-southeast-1
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instances.name]
  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World from Instance 2" > index.html
                python3 -m http.server 8080 &
                EOF
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "demo-devops-directive-web-app-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_db_instance" "postgres_instance" {
  allocated_storage = 10
  engine = "postgres"
  engine_version = "14.4"
  instance_class = "db.t2.micro"
  db_name = "mydb"
  username = "foo"
  password = "foobarbaz"
  skip_final_snapshot = true
}