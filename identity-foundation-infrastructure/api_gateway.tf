locals {
  identity_foundation_api_config_revision_name = "identity-foundation-api-${substr(sha1(local_file.api_swagger.content), 0, 7)}"
}

resource "google_api_gateway_api" "api" {
  project  = var.google_project
  provider = google-beta
  api_id   = "identity-foundation-api"
  depends_on = [
    google_project_service.api_gateway,
    google_project_service.service_control,
    google_project_service.service_management
  ]
}

resource "google_api_gateway_api_config" "api" {
  provider      = google-beta
  project       = var.google_project
  api           = google_api_gateway_api.api.api_id
  api_config_id = local.identity_foundation_api_config_revision_name
  openapi_documents {
    document {
      path     = local_file.api_swagger.filename
      contents = base64encode(local_file.api_swagger.content)
    }
  }
  gateway_config {
    backend_config {
      google_service_account = google_service_account.api.email
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "api" {
  provider   = google-beta
  project    = var.google_project
  region     = var.google_region
  api_config = google_api_gateway_api_config.api.id
  gateway_id = local.identity_foundation_api_config_revision_name
}
