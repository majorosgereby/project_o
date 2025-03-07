resource "kubernetes_namespace_v1" "project_o" {
  metadata {
    name = "project-o-namespace"
  }
}

resource "kubernetes_deployment_v1" "project_o" {
  metadata {
    name      = "project-o"
    namespace = kubernetes_namespace_v1.project_o.metadata[0].name
    labels = {
      app = "project-o"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app  = "project-o"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "project-o"
          tier = "backend"
        }
      }

      spec {
        container {
          name              = "project-o"
          image             = "794038210581.dkr.ecr.eu-west-2.amazonaws.com/majorosgereby/project_o"
          image_pull_policy = "Always"

          port {
            container_port = 3000
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace_v1.project_o]
}

resource "kubernetes_service_v1" "project_o_service" {
  metadata {
    name      = "project-o-service"
    namespace = kubernetes_namespace_v1.project_o.metadata[0].name
  }

  spec {
    selector = {
      app  = "project-o"
      tier = "backend"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment_v1.project_o]
}
