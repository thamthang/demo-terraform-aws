variable "ami" {
    description = "Amazon machine image to use for EC2 instance"
    type = string
    default = "ami-002843b0a9e09324a" // Ubuntu 20.04 LTS x64 ap-southeast-1
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
}

variable "bucket_prefix" {
    description = "Prefix of S3 bucket"
    type = string
}

variable "db_name" {
    description = "Name of database"
    type = string  
}

variable "db_username" {
    description = "Username of database"
    type = string  
}
  
variable "db_password" {
    description = "Password of database"
    type = string
    sensitive = true
}

variable "env_name" {
  description = "Deployment environment (dev/staging/prod)"
  type = string
  default = "dev"
}