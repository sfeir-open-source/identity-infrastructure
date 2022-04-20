resource "google_artifact_registry_repository" "identity_foundation_container_registry" {
  provider      = google-beta
  project       = var.google_project
  location      = var.google_region
  repository_id = "identity-foundation-run"
  description   = "Identity Foundation Run"
  format        = "DOCKER"
}
