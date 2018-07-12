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
