resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>?:."
}

resource "random_id" "secret_suffix" {
  byte_length = 4
}