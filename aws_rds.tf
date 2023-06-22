resource "aws_db_subnet_group" "db-subnet" {
  name = local.name

  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "rds01" {
  allocated_storage = 10
  identifier        = "rds01"
  instance_class    = "db.t2.micro"

  db_subnet_group_name = local.name

  engine         = "mariadb"
  engine_version = "10.6"

  # not available in Free Tier?
  storage_encrypted   = false
  skip_final_snapshot = true

  db_name  = random_string.wp_name.result
  username = random_string.wp_user.result
  password = random_password.wp_pass.result

  depends_on = [aws_db_subnet_group.db-subnet]
}
