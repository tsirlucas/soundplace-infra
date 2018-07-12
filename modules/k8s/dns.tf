variable "domain" {
  default = "api-soundplace.com"
}

resource "google_dns_managed_zone" "default" {
  name        = "soundlace-gateway-zone"
  dns_name    = "${var.domain}."
  description = "soundplace production dns zone"
  project     = "${var.project}"
}

resource "google_dns_record_set" "a" {
  name         = "${google_dns_managed_zone.default.dns_name}"
  managed_zone = "${google_dns_managed_zone.default.name}"
  type         = "A"
  ttl          = 300

  rrdatas = ["${google_compute_global_address.gateway-ingress-address.address}"]

  project = "${var.project}"
}

resource "google_dns_record_set" "cname" {
  name         = "www.${google_dns_managed_zone.default.dns_name}"
  managed_zone = "${google_dns_managed_zone.default.name}"
  type         = "CNAME"
  ttl          = 300

  rrdatas = ["${google_dns_managed_zone.default.dns_name}"]

  project = "${var.project}"
}
