variable "ami" {
  description = "Amazon machine image to use for EC2 instance"
  type        = string
  default     = "ami-002843b0a9e09324a" // Ubuntu 20.04 LTS x64 ap-southeast-1
}

variable "aws_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}