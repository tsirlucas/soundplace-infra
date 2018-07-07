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
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
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

resource "google_container_node_pool" "free-pool" {
  name       = "free-pool"
  cluster    = "${google_container_cluster.soundplace.name}"
  zone       = "us-central1-b"
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "f1-micro"

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

#####################################################################
# Output for K8S
#####################################################################
output "client_certificate" {
  value     = "${google_container_cluster.soundplace.master_auth.0.client_certificate}"
  sensitive = true
}

output "client_key" {
  value     = "${google_container_cluster.soundplace.master_auth.0.client_key}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = "${google_container_cluster.soundplace.master_auth.0.cluster_ca_certificate}"
  sensitive = true
}

output "host" {
  value     = "${google_container_cluster.soundplace.endpoint}"
  sensitive = true
}
