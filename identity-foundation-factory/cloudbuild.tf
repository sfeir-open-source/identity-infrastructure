locals {
  oathkeeper_container_image_name                  = "${var.google_region}-docker.pkg.dev/${var.google_project}/identity-foundation-run/oathkeeper"
  identity_foundation_account_container_image_name = "${var.google_region}-docker.pkg.dev/${var.google_project}/identity-foundation-run/account"
  identity_foundation_app_container_image_name     = "${var.google_region}-docker.pkg.dev/${var.google_project}/identity-foundation-run/app"
}

resource "google_cloudbuild_trigger" "oathkeeper" {
  project = "${var.google_project}/locations/${var.google_region}"
  name    = "oathkeeper"
  included_files = [
    "identity-foundation-factory/**/*"
  ]
  github {
    owner = "sfeir-open-source"
    name  = "identity-infrastructure"
    push {
      branch = "main"
    }
  }
  build {
    images = [
      local.oathkeeper_container_image_name
    ]
    step {
      name = "gcr.io/cloud-builders/docker@sha256:f42c653aeae55fea4cd318a9443823c77243929dae6bb784b9eef21e1ab40d09"
      args = [
        "pull",
        "docker.io/oryd/oathkeeper@sha256:44d22a42c24ba77cea84ea1523616781d4461284b2f2f8adf6a5602a0aecd3fc"
      ]
    }
    step {
      name = "gcr.io/cloud-builders/docker@sha256:f42c653aeae55fea4cd318a9443823c77243929dae6bb784b9eef21e1ab40d09"
      args = [
        "tag",
        "docker.io/oryd/oathkeeper@sha256:44d22a42c24ba77cea84ea1523616781d4461284b2f2f8adf6a5602a0aecd3fc",
        local.oathkeeper_container_image_name
      ]
    }
  }
  depends_on = [
    google_artifact_registry_repository.identity_foundation_container_registry
  ]
}

resource "google_cloudbuild_trigger" "identity_foundation_account" {
  project = "${var.google_project}/locations/${var.google_region}"
  name    = "identity-foundation-account"
  included_files = [
    "identity-foundation-account/**/*"
  ]
  github {
    owner = "sfeir-open-source"
    name  = "identity-infrastructure"
    push {
      branch = "main"
    }
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
  project = "${var.google_project}/locations/${var.google_region}"
  name    = "identity-foundation-app"
  included_files = [
    "identity-foundation-app/**/*"
  ]
  github {
    owner = "sfeir-open-source"
    name  = "identity-infrastructure"
    push {
      branch = "main"
    }
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
