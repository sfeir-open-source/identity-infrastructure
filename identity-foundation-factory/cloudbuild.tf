locals {
  oathkeeper_container_image_name = join("/", [
    "${google_artifact_registry_repository.identity_foundation_container_registry.location}-docker.pkg.dev",
    "${google_artifact_registry_repository.identity_foundation_container_registry.project}",
    "${google_artifact_registry_repository.identity_foundation_container_registry.repository_id}/oathkeeper"
  ])
  identity_foundation_account_container_image_name = join("/", [
    "${google_artifact_registry_repository.identity_foundation_container_registry.location}-docker.pkg.dev",
    "${google_artifact_registry_repository.identity_foundation_container_registry.project}",
    "${google_artifact_registry_repository.identity_foundation_container_registry.repository_id}/account"
  ])
  identity_foundation_app_container_image_name = join("/", [
    "${google_artifact_registry_repository.identity_foundation_container_registry.location}-docker.pkg.dev",
    "${google_artifact_registry_repository.identity_foundation_container_registry.project}",
    "${google_artifact_registry_repository.identity_foundation_container_registry.repository_id}/app"
  ])
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
      name = var.docker_container_image_name
      args = [
        "pull",
        var.oathkeeper_container_image_name
      ]
    }
    step {
      name = var.docker_container_image_name
      args = [
        "tag",
        var.oathkeeper_container_image_name,
        local.oathkeeper_container_image_name
      ]
    }
  }
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
      name = var.docker_container_image_name
      args = [
        "build",
        "-t",
        local.identity_foundation_account_container_image_name,
        "identity-foundation-account"
      ]
    }
  }
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
      name = var.docker_container_image_name
      args = [
        "build",
        "-t",
        local.identity_foundation_app_container_image_name,
        "identity-foundation-app"
      ]
    }
  }
}
