resource "google_service_account" "oathkeeper" {
  project      = var.google_project
  account_id   = "identity-foundation-oathkeeper"
  display_name = "Oathkeeper Service Account"
}
