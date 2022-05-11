variable "google_project" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "google_region" {
  type        = string
  description = "The Google Cloud region"
}

variable "oauth2_issuer" {
  type        = string
  description = "The OAuth2 issuer URL"
}

variable "oauth2_jwks_uri" {
  type        = string
  description = "The OAuth2 JWKS URI"
}

variable "identity_foundation_account_container_image_name" {
  type        = string
  description = "The container image name for Identity Foundation Account"
}

variable "identity_foundation_app_container_image_name" {
  type        = string
  description = "The container image name for Identity Foundation App"
}

variable "ciphertext_identity_foundation_account_credentials" {
  type        = string
  description = "The credentials for the Identity Foundation Account"
}
