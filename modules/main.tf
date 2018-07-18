#####################################################################
# Variables
#####################################################################
variable "username" {}

variable "password" {}

variable "project" {}
variable "region" {}

variable "credentials" {}

#####################################################################
# Modules
#####################################################################

data "http" "local_ip" {
  url = "http://icanhazip.com"
}

locals {
  local_ip = "${replace(data.http.local_ip.body, "\n", "")}"
}

module "gke" {
  source      = "./gke"
  project     = "${var.project}"
  region      = "${var.region}"
  username    = "${var.username}"
  password    = "${var.password}"
  credentials = "${var.credentials}"
}

module "database" {
  source = "./database"

  username = "${var.username}"
  password = "${var.password}"
  region   = "${var.region}"
  project  = "soundplace-infra"
  local_ip = "${local.local_ip}"
}

module "k8s" {
  source   = "./k8s"
  host     = "${module.gke.host}"
  username = "${var.username}"
  password = "${var.password}"
  region   = "${var.region}"
  project  = "soundplace-infra"

  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"

  database_endpoint = "${module.database.endpoint}"
}
