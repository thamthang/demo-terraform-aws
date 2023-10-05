terraform {
  backend "remote" {
    organization = "thomas-devops-directive"

    workspaces {
      name = "demo-terraform-aws"
    }
  }

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

module "webapp" {
  source = "../modules"
}

output "url" {
  value = "${module.webapp.instance_ip_addr}:8080"
}