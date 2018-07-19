output "endpoint" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address}"
}

output "client_ca_pem" {
  value = "${data.external.pem_generator.result.pem}"
}
