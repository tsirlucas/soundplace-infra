resource "google_compute_global_address" "gateway-ingress-address" {
  name    = "gateway-ingress-address"
  project = "${var.project}"
}

resource "google_compute_address" "gateway-api-address" {
  name    = "gateway-api-address"
  region  = "${var.region}"
  project = "${var.project}"
}

resource "kubernetes_replication_controller" "gateway-api" {
  metadata {
    name = "gateway-api-rc"

    labels {
      app = "gateway-api-rc"
    }
  }

  spec {
    selector = {
      app = "gateway-api-rc"
    }

    template {
      container {
        image = "tsirlucas/soundplace-gateway:latest"
        name  = "gateway-api"

        port {
          container_port = 8080
        }

        env {
          name  = "AUTH_API_ENDPOINT"
          value = "${google_compute_address.auth-api-address.address}"
        }

        env {
          name  = "DATA_API_ENDPOINT"
          value = "${google_compute_address.data-api-address.address}"
        }

        env {
          name  = "GRAPHQL_API_ENDPOINT"
          value = "${google_compute_address.graphql-api-address.address}"
        }

        env {
          name  = "STREAM_API_ENDPOINT"
          value = "${google_compute_address.stream-api-address.address}"
        }

        env {
          name  = "DATABASE_PEM"
          value = "${var.database_client_pem}"
        }
      }
    }
  }
}

resource "kubernetes_service" "gateway-api" {
  metadata {
    name = "gateway-api-service"
  }

  spec {
    load_balancer_ip = "${google_compute_address.gateway-api-address.address}"

    selector {
      app = "${kubernetes_replication_controller.gateway-api.metadata.0.labels.app}"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8080
    }

    port {
      name        = "https"
      port        = 443
      target_port = 8080
    }

    type = "LoadBalancer"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f modules/k8s/ingress/gateway_ingress.yaml"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete ingress gateway-ingress"
  }
}
