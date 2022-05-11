locals {
  identity_foundation_app_config_revision_name = "identity-foundation-app-${substr(sha1(local_file.app_swagger.content), 0, 7)}"
  account_config_revision_name                 = "identity-foundation-account-${substr(sha1(local_file.account_swagger.content), 0, 7)}"
}

resource "google_api_gateway_api" "app" {
  project      = var.google_project
  provider     = google-beta
  display_name = "Identity Foundation App"
  api_id       = "identity-foundation-app"
}

resource "google_api_gateway_api_config" "app" {
  provider      = google-beta
  project       = var.google_project
  api           = google_api_gateway_api.app.api_id
  api_config_id = local.identity_foundation_app_config_revision_name
  openapi_documents {
    document {
      path     = local_file.app_swagger.filename
      contents = base64encode(local_file.app_swagger.content)
    }
  }
  gateway_config {
    backend_config {
      google_service_account = google_service_account.apis.email
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "app" {
  provider   = google-beta
  project    = var.google_project
  region     = var.google_region
  api_config = google_api_gateway_api_config.app.id
  gateway_id = local.identity_foundation_app_config_revision_name
}

resource "google_api_gateway_api" "account" {
  project      = var.google_project
  provider     = google-beta
  display_name = "Identity Foundation Account"
  api_id       = "identity-foundation-account"
}

resource "google_api_gateway_api_config" "account" {
  provider      = google-beta
  project       = var.google_project
  api           = google_api_gateway_api.account.api_id
  api_config_id = local.account_config_revision_name
  openapi_documents {
    document {
      path     = local_file.account_swagger.filename
      contents = base64encode(local_file.account_swagger.content)
    }
  }
  gateway_config {
    backend_config {
      google_service_account = google_service_account.apis.email
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "account" {
  provider   = google-beta
  project    = var.google_project
  region     = var.google_region
  api_config = google_api_gateway_api_config.account.id
  gateway_id = local.account_config_revision_name
}
