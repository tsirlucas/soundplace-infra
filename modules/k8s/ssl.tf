resource "google_compute_ssl_certificate" "default" {
  name        = "gateway-cert"
  description = "Gateway certificate"
  private_key = "${file(".secrets/ssl/api-soundplace.com.key")}"
  certificate = "${file(".secrets/ssl/api-soundplace.com.crt")}"

  lifecycle {
    create_before_destroy = true
  }

  project = "${var.project}"
}
