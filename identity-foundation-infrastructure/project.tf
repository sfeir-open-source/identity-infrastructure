resource "google_project_service" "api_gateway" {
  project                    = var.google_project
  service                    = "apigateway.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "service_control" {
  project                    = var.google_project
  service                    = "servicecontrol.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "service_management" {
  project                    = var.google_project
  service                    = "servicemanagement.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "logging" {
  project                    = var.google_project
  service                    = "logging.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "cloud_error_reporting" {
  project                    = var.google_project
  service                    = "clouderrorreporting.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "run" {
  project                    = var.google_project
  service                    = "run.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
