resource "kubernetes_replication_controller" "stream-api-master" {
  metadata {
    name = "stream-api-master"

    labels {
      app  = "stream"
      role = "master"
      tier = "api"
    }
  }

  spec {
    replicas = 1

    selector = {
      app  = "stream"
      role = "master"
      tier = "api"
    }

    template {
      container {
        image = "tsirlucas/youtube-cacheable-audio-stream:latest"
        name  = "master"

        port {
          container_port = 1337
        }

        resources {
          requests {
            cpu    = "100m"
            memory = "100Mi"
          }
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "stream-api-slave" {
  metadata {
    name = "stream-api-slave"

    labels {
      app  = "stream-api"
      role = "slave"
      tier = "api"
    }
  }

  spec {
    replicas = 2

    selector = {
      app  = "stream-api"
      role = "slave"
      tier = "api"
    }

    template {
      container {
        image = "tsirlucas/youtube-cacheable-audio-stream:latest"
        name  = "slave"

        port {
          container_port = 1337
        }

        env {
          name  = "GET_HOSTS_FROM"
          value = "dns"
        }

        resources {
          requests {
            cpu    = "100m"
            memory = "100Mi"
          }
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "data-api-master" {
  metadata {
    name = "data-api-master"

    labels {
      app  = "data"
      role = "master"
      tier = "api"
    }
  }

  spec {
    replicas = 1

    selector = {
      app  = "data"
      role = "master"
      tier = "api"
    }

    template {
      container {
        image = "tsirlucas/soundplace-api:latest"
        name  = "master"

        port {
          container_port = 6379
        }

        resources {
          requests {
            cpu    = "100m"
            memory = "100Mi"
          }
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "data-api-slave" {
  metadata {
    name = "data-api-slave"

    labels {
      app  = "soundplace-api"
      role = "slave"
      tier = "api"
    }
  }

  spec {
    replicas = 2

    selector = {
      app  = "data-api"
      role = "slave"
      tier = "api"
    }

    template {
      container {
        image = "tsirlucas/soundplace-api:latest"
        name  = "slave"

        port {
          container_port = 6379
        }

        env {
          name  = "GET_HOSTS_FROM"
          value = "dns"
        }

        resources {
          requests {
            cpu    = "100m"
            memory = "100Mi"
          }
        }
      }
    }
  }
}
