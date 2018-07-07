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
      port        = 3001
      target_port = 3001
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
      port        = 3001
      target_port = 3001
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
      port        = 3000
      target_port = 3000
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
      port        = 3000
      target_port = 3000
    }
  }
}
