module "oathkeeper" {
  source                                 = "../identity-foundation-oathkeeper"
  oathkeeper_proxy_public_url            = var.oathkeeper_proxy_public_url
  identity_foundation_account_public_url = var.identity_foundation_account_public_url
  identity_foundation_app_public_url     = var.identity_foundation_app_public_url
  id_token_jwks_url                      = "file:///secrets/idtoken-jwks/id_token.jwks.json"
  oathkeeper_access_rules_repositories = [
    "file:///secrets/oathkeeper-access-rules/access-rules.yaml"
  ]
}
