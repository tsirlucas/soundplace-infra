output "endpoint" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address}"
}

output "db_name" {
  value = "${google_sql_database.soundplace.name}"
}

output "client_ca_pem" {
  value = "${lookup(data.external.pem_generator.result, "pem")}"
}
