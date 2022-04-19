output "oathkeeper_proxy_service_url" {
  value = google_cloud_run_service.oathkeeper_proxy.status[0].url
}

output "identity_foundation_account_service_url" {
  value = google_cloud_run_service.identity_foundation_account.status[0].url
}

output "identity_foundation_app_service_url" {
  value = google_cloud_run_service.identity_foundation_app.status[0].url
}
