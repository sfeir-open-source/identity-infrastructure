resource "google_service_account" "runner" {
  project      = var.google_project
  account_id   = "identity-foundation-runner"
  display_name = "Run Service Account"
}

resource "google_service_account" "apis" {
  project      = var.google_project
  account_id   = "identity-foundation-apis"
  display_name = "API Gateway Service Account"
}
