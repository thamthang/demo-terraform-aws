resource "aws_instance" "instance_1" {
  ami             = var.ami
  instance_type   = var.aws_instance_type
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
                #!/bin/bash
                echo "Hello, World from Instance 1" > index.html
                python3 -m http.server 8080 &
                EOF
  tags = {
    Name = "${local.env_name}-web-app-instance-1"
  }
}