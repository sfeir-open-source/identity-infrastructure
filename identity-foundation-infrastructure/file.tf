resource "local_sensitive_file" "jwks" {
  filename = "id_token.jwks.json"
  content = jsonencode({
    keys = jsondecode(data.google_kms_secret.jwks_keys.plaintext)
  })
}
