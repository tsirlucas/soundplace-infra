resource "kubernetes_horizontal_pod_autoscaler" "data-api" {
  metadata {
    name = "data-api-autoscaling"
  }

  spec {
    max_replicas = 3
    min_replicas = 1

    scale_target_ref {
      kind = "ReplicationController"
      name = "${kubernetes_replication_controller.data-api.metadata.0.name}"
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "stream-api" {
  metadata {
    name = "stream-api-autoscaling"
  }

  spec {
    max_replicas = 3
    min_replicas = 1

    scale_target_ref {
      kind = "ReplicationController"
      name = "${kubernetes_replication_controller.stream-api.metadata.0.name}"
    }
  }
}
