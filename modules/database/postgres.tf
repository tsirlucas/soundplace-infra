resource "random_id" "name" {
  byte_length = 3
}

resource "google_sql_database_instance" "master" {
  name             = "soundplace-master-instance-${random_id.name.hex}"
  region           = "${var.region}"
  database_version = "POSTGRES_9_6"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      require_ssl = true

      authorized_networks {
        name  = "everyone"
        value = "0.0.0.0/0"
      }
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "rm .secrets/client_cert.pem"
  }

  project = "${var.project}"
}

resource "google_sql_database" "soundplace" {
  name     = "soundplace"
  instance = "${google_sql_database_instance.master.name}"
  project  = "${var.project}"
}

resource "google_sql_user" "soundplace_database_user" {
  name     = "soundplace"
  instance = "${google_sql_database_instance.master.name}"
  password = "${var.password}"
  project  = "${var.project}"
}

resource "null_resource" "setup_database" {
  provisioner "local-exec" {
    command = "bash modules/database/setup_database.sh"

    environment = {
      HOST_IP    = "${google_sql_database_instance.master.ip_address.0.ip_address}"
      HOST_USER  = "${google_sql_user.soundplace_database_user.name}"
      PGPASSWORD = "${google_sql_user.soundplace_database_user.password}"
      DATABASE   = "${google_sql_database.soundplace.name}"
    }
  }
}

data "external" "pem_generator" {
  program = ["bash", "modules/database/generate_pem.sh"]

  query = {
    project     = "${var.project}"
    db_instance = "${google_sql_database_instance.master.name}"
  }
}
