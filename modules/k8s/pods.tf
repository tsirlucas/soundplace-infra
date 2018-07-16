resource "kubernetes_replication_controller" "auth-api" {
  metadata {
    name = "auth-api-pod"

    labels {
      app = "auth-api-pod"
    }
  }

  spec {
    selector = {
      app = "auth-api-pod"
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
      }
    }
  }
}

resource "kubernetes_replication_controller" "data-api" {
  metadata {
    name = "data-api-pod"

    labels {
      app = "data-api-pod"
    }
  }

  spec {
    selector = {
      app = "data-api-pod"
    }

    template {
      container {
        image = "tsirlucas/soundplace-api:latest"
        name  = "data-api"

        port {
          container_port = 3000
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "stream-api" {
  metadata {
    name = "stream-api-pod"

    labels {
      app = "stream-api-pod"
    }
  }

  spec {
    selector = {
      app = "stream-api-pod"
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
