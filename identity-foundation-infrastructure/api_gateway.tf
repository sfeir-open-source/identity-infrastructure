locals {
  identity_foundation_apis_config_revision_name = "identity-foundation-apis-${substr(sha1(local_file.swagger.content), 0, 7)}"
}

resource "google_api_gateway_api" "apis" {
  project  = var.google_project
  provider = google-beta
  api_id   = "identity-foundation-apis"
}

resource "google_api_gateway_api_config" "apis" {
  provider      = google-beta
  project       = var.google_project
  api           = google_api_gateway_api.apis.api_id
  api_config_id = local.identity_foundation_apis_config_revision_name
  openapi_documents {
    document {
      path     = local_file.swagger.filename
      contents = base64encode(local_file.swagger.content)
    }
  }
  gateway_config {
    backend_config {
      google_service_account = google_service_account.apis.email
    }
  }
}

resource "google_api_gateway_gateway" "apis" {
  provider   = google-beta
  project    = var.google_project
  region     = var.google_region
  api_config = google_api_gateway_api_config.apis.id
  gateway_id = local.identity_foundation_apis_config_revision_name
}
