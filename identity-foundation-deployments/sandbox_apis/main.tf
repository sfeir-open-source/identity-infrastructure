module "sandbox_apis" {
  source                                             = "../../identity-foundation-apis"
  google_project                                     = "sandbox-348610"
  google_region                                      = "europe-west1"
  identity_foundation_account_container_image_name   = "europe-west1-docker.pkg.dev/sandbox-348610/identity-foundation-run/account@sha256:d2cfc6a25d620d237f999a8f277f7cc38a3718eab5a9f56050c8c5b74178c700"
  identity_foundation_app_container_image_name       = "europe-west1-docker.pkg.dev/sandbox-348610/identity-foundation-run/app@sha256:91c03efd640662ef081eb44674a750b0be9c3346bfc80b1c6dab2e943deaac57"
  oauth2_issuer                                      = "https://oathkeeper-api-pmbsiqdwuq-ew.a.run.app"
  oauth2_jwks_uri                                    = "https://oathkeeper-api-pmbsiqdwuq-ew.a.run.app/.well-known/jwks.json"
  ciphertext_identity_foundation_account_credentials = "CiQAQr4CUU6VdyrbhnDFCmEyJnCeP4knGfiTuLpIQKDbq+yQjnMSZgBPNksLZc0uc74JnKyVkCiT731Bxk3bMTo3RK8NGEykkXs6+eijcqwN+njB/GAEeJgey5i3Itc7Ncssjhla0GPtY2H2mjJJkHp7KIYacg1kSLEHfqbDWt0MnXsrIDAY94gT9RUMVQ=="
}
