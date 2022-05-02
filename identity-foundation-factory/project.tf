resource "google_project_service" "artifact_registry" {
  project                    = var.google_project
  service                    = "artifactregistry.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "cloud_build" {
  project                    = var.google_project
  service                    = "cloudbuild.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "kms" {
  project                    = var.google_project
  service                    = "cloudkms.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "secret_manager" {
  project                    = var.google_project
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
