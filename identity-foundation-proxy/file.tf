resource "local_sensitive_file" "jwks" {
  filename = "${path.module}/id_token.jwks.json"
  content  = jsonencode(jsondecode(data.google_kms_secret.jwks_keys.plaintext))
}
