resource "local_sensitive_file" "jwks" {
  filename = "id_token.jwks.json"
  content = jsonencode({
    keys = var.jwks_keys
  })
}
