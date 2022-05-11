locals {
  identity_foundation_account_credentials = jsondecode(data.google_kms_secret.identity_foundation_account_credentials.plaintext)
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

resource "google_cloud_run_service_iam_member" "identity_foundation_account_apis_run_invoker" {
  project  = var.google_project
  service  = google_cloud_run_service.identity_foundation_account.name
  location = google_cloud_run_service.identity_foundation_account.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.apis.email}"
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

resource "google_cloud_run_service_iam_member" "identity_foundation_app_apis_run_invoker" {
  project  = var.google_project
  service  = google_cloud_run_service.identity_foundation_app.name
  location = google_cloud_run_service.identity_foundation_app.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.apis.email}"
}
