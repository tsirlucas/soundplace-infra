resource "kubernetes_service" "auth-api" {
  metadata {
    name = "auth-api-service"
  }

  spec {
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

resource "kubernetes_service" "graphql-api" {
  metadata {
    name = "graphql-api-service"
  }

  spec {
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
