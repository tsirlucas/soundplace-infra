#####################################################################
# Google Cloud Platform
#####################################################################
provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.credentials}"
}
