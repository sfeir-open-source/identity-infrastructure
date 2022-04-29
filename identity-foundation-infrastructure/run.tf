locals {
  oathkeeper_access_rules_secret_version  = tonumber(element(split("/", google_secret_manager_secret_version.oathkeeper_access_rules.name), 5))
  oathkeeper_config_secret_version        = tonumber(element(split("/", google_secret_manager_secret_version.oathkeeper_config.name), 5))
  idtoken_jwks_secret_version             = tonumber(element(split("/", google_secret_manager_secret_version.idtoken_jwks.name), 5))
  identity_foundation_account_credentials = jsondecode(data.google_kms_secret.identity_foundation_account_credentials.plaintext)
}

resource "google_cloud_run_service" "oathkeeper_proxy" {
  project                    = var.google_project
  name                       = "oathkeeper-proxy"
  location                   = var.google_region
  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    spec {
      containers {
        image = var.oathkeeper_container_image_name
        ports {
          container_port = 4455
        }
        args = [
          "serve",
          "-c",
          "/secrets/oathkeeper-config/oathkeeper.json"
        ]
        resources {
          limits = {
            cpu    = "1000m"
            memory = "128Mi"
          }
        }
        volume_mounts {
          name       = "oathkeeper-access-rules"
          mount_path = "/secrets/oathkeeper-access-rules"
        }
        volume_mounts {
          name       = "oathkeeper-config"
          mount_path = "/secrets/oathkeeper-config"
        }
        volume_mounts {
          name       = "idtoken-jwks"
          mount_path = "/secrets/idtoken-jwks"
        }
      }
      service_account_name = google_service_account.runner.email
      volumes {
        name = "oathkeeper-access-rules"
        secret {
          secret_name  = data.google_secret_manager_secret.oathkeeper_access_rules.secret_id
          default_mode = 256
          items {
            key  = local.oathkeeper_access_rules_secret_version
            path = "access-rules.json"
          }
        }
      }
      volumes {
        name = "oathkeeper-config"
        secret {
          secret_name  = data.google_secret_manager_secret.oathkeeper_config.secret_id
          default_mode = 256
          items {
            key  = local.oathkeeper_config_secret_version
            path = "oathkeeper.json"
          }
        }
      }
      volumes {
        name = "idtoken-jwks"
        secret {
          secret_name  = data.google_secret_manager_secret.idtoken_jwks.secret_id
          default_mode = 256
          items {
            key  = local.idtoken_jwks_secret_version
            path = "id_token.jwks.json"
          }
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }

  depends_on = [
    google_project_iam_member.runner_secret_manager_secret_accessor
  ]
}

resource "google_cloud_run_service_iam_member" "oathkeeper_proxy_all_user_run_invoker" {
  project  = var.google_project
  service  = google_cloud_run_service.oathkeeper_proxy.name
  location = google_cloud_run_service.oathkeeper_proxy.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service" "oathkeeper_api" {
  project                    = var.google_project
  name                       = "oathkeeper-api"
  location                   = var.google_region
  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    spec {
      containers {
        image = var.oathkeeper_container_image_name
        ports {
          container_port = 4456
        }
        args = [
          "serve",
          "-c",
          "/secrets/oathkeeper-config/oathkeeper.json"
        ]
        resources {
          limits = {
            cpu    = "1000m"
            memory = "128Mi"
          }
        }
        volume_mounts {
          name       = "oathkeeper-access-rules"
          mount_path = "/secrets/oathkeeper-access-rules"
        }
        volume_mounts {
          name       = "oathkeeper-config"
          mount_path = "/secrets/oathkeeper-config"
        }
        volume_mounts {
          name       = "idtoken-jwks"
          mount_path = "/secrets/idtoken-jwks"
        }
      }
      service_account_name = google_service_account.runner.email
      volumes {
        name = "oathkeeper-access-rules"
        secret {
          secret_name  = data.google_secret_manager_secret.oathkeeper_access_rules.secret_id
          default_mode = 256
          items {
            key  = local.oathkeeper_access_rules_secret_version
            path = "access-rules.json"
          }
        }
      }
      volumes {
        name = "oathkeeper-config"
        secret {
          secret_name  = data.google_secret_manager_secret.oathkeeper_config.secret_id
          default_mode = 256
          items {
            key  = local.oathkeeper_config_secret_version
            path = "oathkeeper.json"
          }
        }
      }
      volumes {
        name = "idtoken-jwks"
        secret {
          secret_name  = data.google_secret_manager_secret.idtoken_jwks.secret_id
          default_mode = 256
          items {
            key  = local.idtoken_jwks_secret_version
            path = "id_token.jwks.json"
          }
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }

  depends_on = [
    google_project_iam_member.runner_secret_manager_secret_accessor
  ]
}

resource "google_cloud_run_service_iam_member" "oathkeeper_api_all_user_run_invoker" {
  project  = var.google_project
  service  = google_cloud_run_service.oathkeeper_api.name
  location = google_cloud_run_service.oathkeeper_api.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service" "identity_foundation_account" {
  project                    = var.google_project
  name                       = "identity-foundation-account"
  location                   = var.google_region
  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    spec {
      containers {
        image = var.identity_foundation_account_container_image_name
        ports {
          container_port = 80
        }
        resources {
          limits = {
            cpu    = "1000m"
            memory = "128Mi"
          }
        }
        env {
          name  = "USERNAME"
          value = local.identity_foundation_account_credentials.username
        }
        env {
          name  = "PASSWORD"
          value = local.identity_foundation_account_credentials.password
        }
      }
      service_account_name = google_service_account.runner.email
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "identity_foundation_account_all_user_run_invoker" {
  project  = var.google_project
  service  = google_cloud_run_service.identity_foundation_account.name
  location = google_cloud_run_service.identity_foundation_account.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service" "identity_foundation_app" {
  project                    = var.google_project
  name                       = "identity-foundation-app"
  location                   = var.google_region
  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    spec {
      containers {
        image = var.identity_foundation_app_container_image_name
        ports {
          container_port = 3000
        }
        resources {
          limits = {
            cpu    = "1000m"
            memory = "256Mi"
          }
        }
      }
      service_account_name = google_service_account.runner.email
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "identity_foundation_app_all_user_run_invoker" {
  project  = var.google_project
  service  = google_cloud_run_service.identity_foundation_app.name
  location = google_cloud_run_service.identity_foundation_app.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
