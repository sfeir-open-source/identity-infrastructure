module "oathkeeper" {
  source                                 = "../identity-foundation-oathkeeper"
  oathkeeper_proxy_public_url            = var.oathkeeper_proxy_public_url
  identity_foundation_account_public_url = var.identity_foundation_account_public_url
  identity_foundation_app_public_url     = var.identity_foundation_app_public_url
  id_token_jwks_url                      = var.id_token_jwks_url
}

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

resource "google_project_iam_member" "project" {
  project = var.google_project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.runner.email}"
}
