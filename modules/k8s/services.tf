resource "google_compute_address" "auth-api-address" {
  name    = "auth-api-address"
  region  = "${var.region}"
  project = "${var.project}"
}

resource "kubernetes_service" "auth-api" {
  metadata {
    name = "auth-api-service"
  }

  spec {
    load_balancer_ip = "${google_compute_address.auth-api-address.address}"

    selector {
      app = "${kubernetes_replication_controller.auth-api.metadata.0.labels.app}"
    }

    port {
      port        = 80
      target_port = 3003
    }

    type = "LoadBalancer"
  }
}

resource "google_compute_address" "data-api-address" {
  name    = "data-api-address"
  region  = "${var.region}"
  project = "${var.project}"
}

resource "kubernetes_service" "data-api" {
  metadata {
    name = "data-api-service"
  }

  spec {
    load_balancer_ip = "${google_compute_address.data-api-address.address}"

    selector {
      app = "${kubernetes_replication_controller.data-api.metadata.0.labels.app}"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

resource "google_compute_address" "graphql-api-address" {
  name    = "graphql-api-address"
  region  = "${var.region}"
  project = "${var.project}"
}

resource "kubernetes_service" "graphql-api" {
  metadata {
    name = "graphql-api-service"
  }

  spec {
    load_balancer_ip = "${google_compute_address.graphql-api-address.address}"

    selector {
      app = "${kubernetes_replication_controller.graphql-api.metadata.0.labels.app}"
    }

    port {
      port        = 80
      target_port = 3004
    }

    type = "LoadBalancer"
  }
}

resource "google_compute_address" "stream-api-address" {
  name    = "stream-api-address"
  region  = "${var.region}"
  project = "${var.project}"
}

resource "kubernetes_service" "stream-api" {
  metadata {
    name = "stream-api-service"
  }

  spec {
    load_balancer_ip = "${google_compute_address.stream-api-address.address}"

    selector {
      app = "${kubernetes_replication_controller.stream-api.metadata.0.labels.app}"
    }

    port {
      port        = 80
      target_port = 3001
    }

    type = "LoadBalancer"
  }
}
