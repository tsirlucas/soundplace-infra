resource "kubernetes_service" "stream-master" {
  metadata {
    name = "stream-master"

    labels {
      app  = "stream"
      role = "master"
      tier = "api"
    }
  }

  spec {
    selector {
      app  = "stream"
      role = "master"
      tier = "api"
    }

    port {
      port        = 1337
      target_port = 1337
    }
  }
}

resource "kubernetes_service" "stream-slave" {
  metadata {
    name = "stream-slave"

    labels {
      app  = "stream"
      role = "slave"
      tier = "api"
    }
  }

  spec {
    selector {
      app  = "stream"
      role = "slave"
      tier = "api"
    }

    port {
      port        = 1337
      target_port = 1337
    }
  }
}

resource "kubernetes_service" "data-master" {
  metadata {
    name = "data-master"

    labels {
      app  = "data"
      role = "master"
      tier = "api"
    }
  }

  spec {
    selector {
      app  = "data"
      role = "master"
      tier = "api"
    }

    port {
      port        = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_service" "data-slave" {
  metadata {
    name = "data-slave"

    labels {
      app  = "data"
      role = "slave"
      tier = "api"
    }
  }

  spec {
    selector {
      app  = "data"
      role = "slave"
      tier = "api"
    }

    port {
      port        = 6379
      target_port = 6379
    }
  }
}
