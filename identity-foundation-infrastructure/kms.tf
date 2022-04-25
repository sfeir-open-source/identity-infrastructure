data "google_kms_key_ring" "terraform" {
  project  = var.google_project
  name     = "terraform"
  location = var.google_region
}

data "google_kms_crypto_key" "sensible" {
  name     = "sensible"
  key_ring = data.google_kms_key_ring.terraform.id
}

data "google_kms_secret" "jwks_keys" {
  crypto_key = data.google_kms_crypto_key.sensible.id
  ciphertext = var.ciphertext_jwks_keys
}
