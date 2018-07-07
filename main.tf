#####################################################################
# Production
#####################################################################
variable "GENERAL_USER" {}

variable "GENERAL_PASSWORD" {}

module "soundplace" {
  source = "./modules"

  project  = "soundplace-infra"
  region   = "us-central1"
  username = "${var.GENERAL_USER}"
  password = "${var.GENERAL_PASSWORD}"
}

# Bucket for tfstate
terraform {
  backend "gcs" {
    bucket  = "soundplace-tfstate"
    project = "soundplace-infra"
    key     = "terraform.tfstate"
  }
}
