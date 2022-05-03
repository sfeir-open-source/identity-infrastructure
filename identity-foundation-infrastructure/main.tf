module "oathkeeper" {
  source                          = "../identity-foundation-oathkeeper"
  oathkeeper_proxy_public_url     = var.oathkeeper_proxy_public_url
  oathkeeper_api_public_url       = var.oathkeeper_api_public_url
  identity_foundation_account_url = local.identity_foundation_account_url
  identity_foundation_app_url     = local.identity_foundation_app_url
  identity_foundation_apis_url    = "https://${google_api_gateway_gateway.apis.default_hostname}"
  id_token_jwks_url               = "file:///secrets/idtoken-jwks/id_token.jwks.json"
  oathkeeper_access_rules_repositories = [
    "file:///secrets/oathkeeper-access-rules/access-rules.json"
  ]
}
