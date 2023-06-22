resource "random_string" "wp_user" {
  length = 8
  special = false
}

resource "random_password" "wp_pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_string" "wp_name" {
  length = 8
  special = false
}

resource "random_string" "wp_prefix" {
  length = 8
  special = false
}