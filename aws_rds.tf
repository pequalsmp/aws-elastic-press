resource "aws_db_instance" "rds01" {
  allocated_storage = 10
  identifier        = "rds01"
  instance_class    = "db.t2.micro"

  engine              = "mariadb"
  engine_version      = "10.6"
  storage_encrypted   = false
  skip_final_snapshot = true

  db_name  = random_string.wp_name.result
  username = random_string.wp_user.result
  password = random_password.wp_pass.result
}
