terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.17"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.17"
    }
  }
  required_version = "~> 1.0"
}
