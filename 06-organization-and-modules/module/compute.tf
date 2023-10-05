resource "aws_instance" "instance_1" {
    ami = var.ami
    instance_type = var.instance_type 
    security_groups =  [aws_security_group.instances.name]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World from Instance 1" > index.html
                python3 -m http.server 8080 &
                EOF
    tags = {
      Name = "${var.env_name}-web-app-instance-1"
    }
}

resource "aws_instance" "instance_2" {
  ami = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.instances.name]
  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World from Instance 2" > index.html
                python3 -m http.server 8080 &
                EOF
  tags = {
      Name = "${var.env_name}-web-app-instance-2"
    }
}