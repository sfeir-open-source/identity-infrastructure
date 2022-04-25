resource "google_kms_key_ring" "terraform" {
  project  = var.google_project
  name     = "terraform"
  location = var.google_region
}

resource "google_kms_crypto_key" "sensible" {
  name            = "sensible"
  key_ring        = google_kms_key_ring.terraform.id
  rotation_period = "86400s"
  purpose         = "ENCRYPT_DECRYPT"
}
