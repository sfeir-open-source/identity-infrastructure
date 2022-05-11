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

variable "oathkeeper_proxy_public_url" {
  type        = string
  description = "The public URL of the Oathkeeper proxy service"
}

variable "oathkeeper_api_public_url" {
  type        = string
  description = "The public URL of the Oathkeeper API service"
}

variable "identity_foundation_account_public_url" {
  type        = string
  description = "The public URL of the identity-foundation-account service"
  default     = "http://identity-foundation-account"
}

variable "identity_foundation_app_public_url" {
  type        = string
  description = "The public URL of the identity-foundation-app service"
  default     = "http://identity-foundation-app:3000"
}

variable "identity_foundation_account_url" {
  type        = string
  description = "The public URL of the identity-foundation-account service"
}

variable "identity_foundation_app_url" {
  type        = string
  description = "The public URL of the identity-foundation-app service"
}

variable "ciphertext_jwks_keys" {
  type        = string
  description = "The JSON Web Key which is used to validate the signature of a signed JWT"
}
