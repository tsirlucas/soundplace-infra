resource "kubernetes_replication_controller" "auth-api" {
  metadata {
    name = "auth-api-rc"

    labels {
      app = "auth-api-rc"
    }
  }

  spec {
    selector = {
      app = "auth-api-rc"
    }

    template {
      container {
        image = "tsirlucas/soundplace-auth:latest"
        name  = "auth-api"

        port {
          container_port = 3003
        }

        env {
          name  = "API_URL"
          value = "https://${var.domain}"
        }

        env {
          name  = "CLIENT_URL"
          value = "https://www.soundplace.io"
        }

        env {
          name  = "DATABASE_ENDPOINT"
          value = "${var.database_endpoint}"
        }

        env {
          name  = "DATABASE_NAME"
          value = "${var.database_name}"
        }

        env {
          name  = "DATABASE_USER"
          value = "${var.username}"
        }

        env {
          name  = "DATABASE_PASSWORD"
          value = "${var.password}"
        }

        env {
          name  = "DATABASE_PEM"
          value = "${var.database_client_pem}"
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "data-api" {
  metadata {
    name = "data-api-rc"

    labels {
      app = "data-api-rc"
    }
  }

  spec {
    selector = {
      app = "data-api-rc"
    }

    template {
      container {
        image = "tsirlucas/soundplace-api:latest"
        name  = "data-api"

        port {
          container_port = 3000
        }

        env {
          name  = "AUTH_API_ENDPOINT"
          value = "${kubernetes_service.auth-api.load_balancer_ingress.0.ip}"
        }

        env {
          name  = "DATABASE_ENDPOINT"
          value = "${var.database_endpoint}"
        }

        env {
          name  = "DATABASE_NAME"
          value = "${var.database_name}"
        }

        env {
          name  = "DATABASE_USER"
          value = "${var.username}"
        }

        env {
          name  = "DATABASE_PASSWORD"
          value = "${var.password}"
        }

        env {
          name  = "DATABASE_PEM"
          value = "${var.database_client_pem}"
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "graphql-api" {
  metadata {
    name = "graphql-api-rc"

    labels {
      app = "graphql-api-rc"
    }
  }

  spec {
    selector = {
      app = "graphql-api-rc"
    }

    template {
      container {
        image = "tsirlucas/soundplace-graphql:latest"
        name  = "graphql-api"

        port {
          container_port = 3004
        }

        env {
          name  = "AUTH_API_ENDPOINT"
          value = "${kubernetes_service.auth-api.load_balancer_ingress.0.ip}"
        }

        env {
          name  = "DATABASE_ENDPOINT"
          value = "${var.database_endpoint}"
        }

        env {
          name  = "DATABASE_NAME"
          value = "${var.database_name}"
        }

        env {
          name  = "DATABASE_USER"
          value = "${var.username}"
        }

        env {
          name  = "DATABASE_PASSWORD"
          value = "${var.password}"
        }

        env {
          name  = "DATABASE_PEM"
          value = "${var.database_client_pem}"
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "stream-api" {
  metadata {
    name = "stream-api-rc"

    labels {
      app = "stream-api-rc"
    }
  }

  spec {
    selector = {
      app = "stream-api-rc"
    }

    template {
      container {
        image = "tsirlucas/youtube-cacheable-audio-stream:latest"
        name  = "stream-api"

        port {
          container_port = 3001
        }
      }
    }
  }
}
