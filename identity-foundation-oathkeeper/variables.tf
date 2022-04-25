variable "oathkeeper_proxy_public_url" {
  type        = string
  description = "The public URL of the Oathkeeper proxy service"
  default     = "http://127.0.0.1:4455"
}

variable "identity_foundation_account_public_url" {
  type        = string
  description = "The public URL of the identity-foundation-account service"
  default     = "http://identity-foundation-account"
}

variable "identity_foundation_app_public_url" {
  type        = string
  description = "The public URL of the identity-foundation-app service"
  default     = "http://identity-foundation-app:3000"
}

variable "id_token_jwks_url" {
  type        = string
  description = "The JSON Web Key which is used to validate the signature of a signed JWT"
  default     = "file:///etc/ory/oathkeeper/id_token.jwks.json"
}

variable "oathkeeper_access_rules_repositories" {
  type = list(string)
  description = "The list of repositories which contain the Oathkeeper access rules"
  default = [
    "file:///etc/ory/oathkeeper/access-rules.yaml"
  ]
}
