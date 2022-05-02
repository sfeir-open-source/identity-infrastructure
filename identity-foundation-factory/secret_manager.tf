resource "google_secret_manager_secret" "oathkeeper_access_rules" {
  project   = var.google_project
  secret_id = "oathkeeper-access-rules"
  replication {
    automatic = true
  }
  depends_on = [
    google_project_service.secret_manager
  ]
}

resource "google_secret_manager_secret" "oathkeeper_config" {
  project   = var.google_project
  secret_id = "oathkeeper-config"
  replication {
    automatic = true
  }
  depends_on = [
    google_project_service.secret_manager
  ]
}

resource "google_secret_manager_secret" "idtoken_jwks" {
  project   = var.google_project
  secret_id = "idtoken-jwks"
  replication {
    automatic = true
  }
  depends_on = [
    google_project_service.secret_manager
  ]
}
