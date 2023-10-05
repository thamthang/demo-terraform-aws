terraform {
  backend "remote" {
    organization = "thomas-devops-directive"

    workspaces {
      prefix = "demo-terraform-aws-" // need to use prefix key
    }
  }

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "webapp" {
  source = "../../06-organization-and-modules/module"

  # Input variables
  env_name = local.environment
  bucket_prefix = "demo-directive-webapp-tf-3"
  db_name = "mydb"
  db_username = "foo"
  db_password = var.db_password
}