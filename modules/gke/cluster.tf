#####################################################################
# GKE Cluster
#####################################################################
resource "google_container_cluster" "soundplace" {
  name                     = "soundplace"
  zone                     = "us-central1-b"
  remove_default_node_pool = true

  node_pool {
    name = "default-pool"
  }

  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }

  lifecycle {
    ignore_changes = [
      "node_pool",
    ]
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials soundplace --zone us-central1-b"
  }
}

#####################################################################
# Node pool
#####################################################################
resource "google_container_node_pool" "primary-pool" {
  name               = "primary-pool"
  cluster            = "${google_container_cluster.soundplace.name}"
  zone               = "us-central1-b"
  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
