resource "aws_db_instance" "postgres_instance" {
  allocated_storage = 10
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "15.2"
  instance_class = "db.t3.micro"
  identifier = "${var.env_name}-demo-postgresql"
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  skip_final_snapshot = true
}