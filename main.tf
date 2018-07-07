#####################################################################
# Production
#####################################################################
variable "GENERAL_USER" {}

variable "GENERAL_PASSWORD" {}

variable "GCLOUD_CREDENTIALS_PATH" {
  default = ".secrets/gcloud_auth.json"
}

module "soundplace" {
  source = "./modules"

  project     = "soundplace-infra"
  region      = "us-central1"
  username    = "${var.GENERAL_USER}"
  password    = "${var.GENERAL_PASSWORD}"
  credentials = "${var.GCLOUD_CREDENTIALS_PATH}"
}

# Bucket for tfstate
terraform {
  backend "gcs" {
    bucket      = "soundplace-tfstate"
    project     = "soundplace-infra"
    prefix      = "terraform.tfstate"
    credentials = ".secrets/gcloud_auth.json"
  }
}
