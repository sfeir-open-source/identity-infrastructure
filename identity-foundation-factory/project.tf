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

resource "google_project_service" "api_gateway" {
  project                    = var.google_project
  service                    = "apigateway.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}

resource "google_project_service" "service_control" {
  project                    = var.google_project
  service                    = "servicecontrol.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}

resource "google_project_service" "service_management" {
  project                    = var.google_project
  service                    = "servicemanagement.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}

resource "google_project_service" "cloud_error_reporting" {
  project                    = var.google_project
  service                    = "clouderrorreporting.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}

resource "google_project_service" "run" {
  project                    = var.google_project
  service                    = "run.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}
