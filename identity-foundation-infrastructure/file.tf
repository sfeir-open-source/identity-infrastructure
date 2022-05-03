resource "local_sensitive_file" "jwks" {
  filename = "${path.module}/id_token.jwks.json"
  content  = jsonencode(jsondecode(data.google_kms_secret.jwks_keys.plaintext))
}

resource "local_file" "swagger" {
  filename = "swagger.json"
  content = jsonencode({
    swagger = "2.0"
    info = {
      title   = "Identity Foundation APIs"
      version = "1.0.0"
    }
    schemes = [
      "https"
    ]
    produces = [
      "application/json"
    ]
    paths = {
      "/app/{subpath=**}" = {
        for method in ["get", "post", "put", "delete"] :
        method => {
          summary     = "identity-foundation-apps"
          operationId = "identity-foundation-apps-${method}"
          x-google-backend = {
            address          = local.identity_foundation_app_url
            path_translation = "APPEND_PATH_TO_ADDRESS"
          }
          responses = {
            default = {
              description = "Response"
            }
          }
          security = [
            { oathkeeper = [] }
          ]
          parameters = [
            {
              in       = "path"
              name     = "subpath"
              type     = "string"
              required = true
            }
          ]
        }
      }
    }
    securityDefinitions = {
      oathkeeper = {
        authorizationUrl   = ""
        flow               = "implicit"
        type               = "oauth2"
        x-google-issuer    = var.oathkeeper_api_public_url
        x-google-jwks_uri  = "${var.oathkeeper_api_public_url}/.well-known/jwks.json"
        x-google-audiences = local.identity_foundation_app_url
        x-google-jwt-locations = [
          {
            header       = "Authorization"
            value_prefix = "Bearer "
          }
        ]
      }
    }
  })
}
