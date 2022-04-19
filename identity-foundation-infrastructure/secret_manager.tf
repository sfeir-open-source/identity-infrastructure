resource "google_secret_manager_secret" "oathkeeper_access_rules" {
  project   = var.google_project
  secret_id = "oathkeeper-access-rules"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "oathkeeper_config" {
  project   = var.google_project
  secret_id = "oathkeeper-config"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "idtoken_jwks" {
  project   = var.google_project
  secret_id = "idtoken-jwks"
  replication {
    automatic = true
  }
}

resource "google_project_iam_member" "project" {
  project = var.google_project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.runner.email}"
}
