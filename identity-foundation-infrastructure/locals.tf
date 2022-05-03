locals {
  identity_foundation_account_url = google_cloud_run_service.identity_foundation_account.status[0].url
  identity_foundation_app_url     = google_cloud_run_service.identity_foundation_app.status[0].url
  identity_foundation_api_url     = "https://${google_api_gateway_gateway.apis.default_hostname}"
}
