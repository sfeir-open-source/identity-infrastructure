locals {
  oathkeeper_container_image_name                  = "${var.google_region}-docker.pkg.dev/${var.google_project}/identity-foundation-run/oathkeeper"
  identity_foundation_account_container_image_name = "${var.google_region}-docker.pkg.dev/${var.google_project}/identity-foundation-run/account"
  identity_foundation_app_container_image_name     = "${var.google_region}-docker.pkg.dev/${var.google_project}/identity-foundation-run/app"
}

resource "google_sourcerepo_repository" "identity_foundation" {
  name = "identity-foundation"
}

resource "google_cloudbuild_trigger" "oathkeeper" {
  included_files = [
    "oathkeeper/**/*"
  ]
  trigger_template {
    tag_name  = var.git_tag_name
    repo_name = google_sourcerepo_repository.identity_foundation.name
  }
  build {
    images = [
      local.oathkeeper_container_image_name
    ]
    step {
      name = "gcr.io/cloud-builders/docker@sha256:f42c653aeae55fea4cd318a9443823c77243929dae6bb784b9eef21e1ab40d09"
      args = [
        "pull",
        "oryd/oathkeeper@sha256:44d22a42c24ba77cea84ea1523616781d4461284b2f2f8adf6a5602a0aecd3fc"
      ]
    }
    step {
      name = "gcr.io/cloud-builders/docker@sha256:f42c653aeae55fea4cd318a9443823c77243929dae6bb784b9eef21e1ab40d09"
      args = [
        "tag",
        "oryd/oathkeeper",
        local.oathkeeper_container_image_name
      ]
    }
    step {
      name = "gcr.io/cloud-builders/docker@sha256:f42c653aeae55fea4cd318a9443823c77243929dae6bb784b9eef21e1ab40d09"
      args = [
        "push",
        local.oathkeeper_container_image_name
      ]
    }
  }
  depends_on = [
    google_artifact_registry_repository.identity_foundation_container_registry
  ]
}

resource "google_cloudbuild_trigger" "identity_foundation_account" {
  included_files = [
    "identity-foundation-account/**/*"
  ]
  trigger_template {
    tag_name  = var.git_tag_name
    repo_name = google_sourcerepo_repository.identity_foundation.name
  }
  build {
    images = [
      local.identity_foundation_account_container_image_name
    ]
    step {
      name = "gcr.io/cloud-builders/docker@sha256:f42c653aeae55fea4cd318a9443823c77243929dae6bb784b9eef21e1ab40d09"
      args = [
        "build",
        "-t",
        local.identity_foundation_account_container_image_name,
        "identity-foundation-account"
      ]
    }
  }
  depends_on = [
    google_artifact_registry_repository.identity_foundation_container_registry
  ]
}

resource "google_cloudbuild_trigger" "identity_foundation_app" {
  included_files = [
    "identity-foundation-app/**/*"
  ]
  trigger_template {
    tag_name  = var.git_tag_name
    repo_name = google_sourcerepo_repository.identity_foundation.name
  }
  build {
    images = [
      local.identity_foundation_app_container_image_name
    ]
    step {
      name = "gcr.io/cloud-builders/docker@sha256:f42c653aeae55fea4cd318a9443823c77243929dae6bb784b9eef21e1ab40d09"
      args = [
        "build",
        "-t",
        local.identity_foundation_app_container_image_name,
        "identity-foundation-app"
      ]
    }
  }
  depends_on = [
    google_artifact_registry_repository.identity_foundation_container_registry
  ]
}

resource "google_artifact_registry_repository" "identity_foundation_container_registry" {
  provider      = google-beta
  project       = var.google_project
  location      = var.google_region
  repository_id = "identity-foundation-run"
  description   = "Identity Foundation Run"
  format        = "DOCKER"
}
