resource "kubernetes_service" "data-api" {
  metadata {
    name = "data-api-service"
  }

  spec {
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

resource "kubernetes_service" "stream-api" {
  metadata {
    name = "stream-api-service"
  }

  spec {
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
