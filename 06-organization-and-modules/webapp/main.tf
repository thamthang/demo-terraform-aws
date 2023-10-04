terraform {
  backend "remote" {
    organization = "thomas-devops-directive"

    workspaces {
      name = "demo-terraform-aws"
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

// In case of local modules, go to app.terraform.io
// Choose Projects & workspaces >> Settings >> General
// Set Default Execution Mode to Local beforing running terraform plan/apply
module "webapp" {
  source = "../module"

  // Input variables
  bucket_prefix = "demo-devops-directive-webapp-tf-2"
  db_name = "mydb"
  db_username = "foo"
  db_password = "foobarbaz"
}