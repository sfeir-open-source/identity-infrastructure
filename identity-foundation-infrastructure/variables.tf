variable "google_project" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "google_region" {
  type        = string
  description = "The Google Cloud region"
}

variable "oathkeeper_container_image_name" {
  type        = string
  description = "The container image name for Oathkeeper"
}

variable "identity_foundation_account_container_image_name" {
  type        = string
  description = "The container image name for Identity Foundation Account"
}

variable "identity_foundation_app_container_image_name" {
  type        = string
  description = "The container image name for Identity Foundation App"
}

variable "oathkeeper_proxy_public_url" {
  type        = string
  description = "The public URL of the Oathkeeper proxy service"
}

variable "identity_foundation_account_public_url" {
  type        = string
  description = "The public URL of the identity-foundation-account service"
}

variable "identity_foundation_app_public_url" {
  type        = string
  description = "The public URL of the identity-foundation-app service"
}
