data "google_secret_manager_secret" "oathkeeper_access_rules" {
  project   = var.google_project
  secret_id = "oathkeeper-access-rules"
}

resource "google_secret_manager_secret_version" "oathkeeper_access_rules" {
  secret      = data.google_secret_manager_secret.oathkeeper_access_rules.id
  secret_data = module.oathkeeper.oathkeeper_access_rules.content
}

data "google_secret_manager_secret" "oathkeeper_config" {
  project   = var.google_project
  secret_id = "oathkeeper-config"
}

resource "google_secret_manager_secret_version" "oathkeeper_config" {
  secret      = data.google_secret_manager_secret.oathkeeper_config.id
  secret_data = module.oathkeeper.oathkeeper_config.content
}

data "google_secret_manager_secret" "idtoken_jwks" {
  project   = var.google_project
  secret_id = "idtoken-jwks"
}

resource "google_secret_manager_secret_version" "idtoken_jwks" {
  secret      = data.google_secret_manager_secret.idtoken_jwks.id
  secret_data = local_sensitive_file.jwks.content
}

resource "google_project_iam_member" "runner_secret_manager_secret_accessor" {
  project = var.google_project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.runner.email}"
}
