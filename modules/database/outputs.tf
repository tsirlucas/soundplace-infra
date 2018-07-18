output "endpoint" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address}"
}
