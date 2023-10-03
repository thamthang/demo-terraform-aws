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

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnet" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

resource "aws_security_group" "instances" {
  name = "instance-security-group"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.instances.id

  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_security_group" "alb" {
  name = "alb-security-group"
}

resource "aws_security_group_rule" "allow_alb_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_alb_outbound" {
  type = "egress"
  security_group_id = aws_security_group.alb.id

  from_port = 0
  to_port = 0
  protocol = "-1" // allow all outbound traffics
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "load_balancer" {
  name = "web-app-load-balancer"
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  subnets = [for subnet in data.aws_subnets.default_subnet.ids : subnet]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = 80
  protocol = "HTTP"

  // return 404 page by default
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_lb_target_group" "instances" {
  name = "web-app-lb-target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id = aws_instance.instance_1.id
  port = 8080
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id = aws_instance.instance_2.id
  port = 8080
}

resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}