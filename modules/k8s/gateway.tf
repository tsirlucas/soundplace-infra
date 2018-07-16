resource "google_compute_global_address" "gateway-ingress-address" {
  name    = "gateway-ingress-address"
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
          value = "${kubernetes_service.auth-api.load_balancer_ingress.0.ip}"
        }

        env {
          name  = "DATA_API_ENDPOINT"
          value = "${kubernetes_service.data-api.load_balancer_ingress.0.ip}"
        }

        env {
          name  = "STREAM_API_ENDPOINT"
          value = "${kubernetes_service.stream-api.load_balancer_ingress.0.ip}"
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
    command = "kubectl apply -f modules/k8s/manual/gateway_ingress.yaml"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete ingress gateway-ingress"
  }
}
