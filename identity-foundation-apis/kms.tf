data "google_kms_key_ring" "terraform" {
  project  = var.google_project
  name     = "terraform"
  location = var.google_region
}

data "google_kms_crypto_key" "sensitive" {
  name     = "sensitive"
  key_ring = data.google_kms_key_ring.terraform.id
}

data "google_kms_secret" "identity_foundation_account_credentials" {
  crypto_key = data.google_kms_crypto_key.sensitive.id
  ciphertext = var.ciphertext_identity_foundation_account_credentials
}
