locals {
  identity_foundation_account_run_url = google_cloud_run_service.identity_foundation_account.status[0].url
  identity_foundation_app_run_url     = google_cloud_run_service.identity_foundation_app.status[0].url
}
