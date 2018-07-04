variable "POSTGRES_USER" {}

variable "POSTGRES_PASSWORD" {}

module "soundplace" {
  source = "./prod"

  POSTGRES_USER     = "${var.POSTGRES_USER}"
  POSTGRES_PASSWORD = "${var.POSTGRES_PASSWORD}"
}
