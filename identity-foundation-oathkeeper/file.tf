resource "local_file" "oathkeeper_access_rules" {
  filename = "${path.module}/access-rules.json"
  content = jsonencode([
    {
      id = "ory:account:anonymous"
      upstream = {
        url = var.identity_foundation_account_public_url
      }
      match = {
        url = "${var.oathkeeper_proxy_public_url}/account/<**>"
        methods = [
          "GET",
          "POST"
        ]
      }
      authenticators = [
        {
          handler = "anonymous"
        }
      ]
      authorizer = {
        handler = "allow"
      }
      mutators = [
        {
          handler = "noop"
        }
      ]
    },
    {
      id = "ory:apis:protected"
      upstream = {
        url        = var.identity_foundation_apis_public_url
        strip_path = "/apis"
      }
      match = {
        url = "${var.oathkeeper_proxy_public_url}/apis/<**>"
        methods = [
          "GET"
        ]
      }
      authenticators = [
        {
          handler = "cookie_session"
        }
      ]
      authorizer = {
        handler = "allow"
      }
      mutators = [
        {
          handler = "id_token"
        }
      ]
      errors = [
        {
          handler = "redirect"
        }
      ]
    },
    {
      id = "ory:app:protected"
      upstream = {
        url = var.identity_foundation_app_public_url
      }
      match = {
        url = "${var.oathkeeper_proxy_public_url}/app/<**>",
        methods = [
          "GET"
        ]
      }
      authenticators = [
        {
          handler = "cookie_session"
        }
      ]
      authorizer = {
        handler = "allow"
      }
      mutators = [
        {
          handler = "id_token"
        }
      ]
      errors = [
        {
          handler = "redirect"
        }
      ]
    }
  ])
}

resource "local_file" "oathkeeper_config" {
  filename = "${path.module}/.oathkeeper.json"
  content = jsonencode({
    version = "v0.38.4-beta.1"
    log = {
      level  = "debug"
      format = "json"
    }
    serve = {
      proxy = {
        cors = {
          enabled = true
          allowed_origins = [
            "*"
          ]
          allowed_methods = [
            "POST",
            "GET",
            "PUT",
            "PATCH",
            "DELETE"
          ]
          allowed_headers = [
            "Authorization",
            "Content-Type"
          ]
          exposed_headers = [
            "Content-Type"
          ]
          allow_credentials = true
          debug             = true
        }
      }
    }
    errors = {
      fallback = [
        "json"
      ]
      handlers = {
        redirect = {
          enabled = true
          config = {
            to = "${var.oathkeeper_proxy_public_url}/account/flow/login.php?return_to=${var.oathkeeper_proxy_public_url}/app/home"
            when = [
              {
                error = [
                  "unauthorized",
                  "forbidden"
                ]
                request = {
                  header = {
                    accept = [
                      "text/html"
                    ]
                  }
                }
              }
            ]
          }
        }
        json = {
          enabled = true
          config = {
            verbose = true
          }
        }
      }
    }
    access_rules = {
      matching_strategy = "glob"
      repositories      = var.oathkeeper_access_rules_repositories
    }
    authenticators = {
      anonymous = {
        enabled = true
        config = {
          subject = "guest"
        }
      }
      cookie_session = {
        enabled = true
        config = {
          check_session_url = "${var.identity_foundation_account_public_url}/account/sessions/whoami.php"
          preserve_path     = true
          extra_from        = "@this"
          subject_from      = "identity.id"
          only = [
            "PHPSESSID"
          ]
        }
      }
      noop = {
        enabled = true
      }
    }
    authorizers = {
      allow = {
        enabled = true
      }
    }
    mutators = {
      noop = {
        enabled = true
      }
      id_token = {
        enabled = true
        config = {
          issuer_url = var.oathkeeper_api_public_url
          jwks_url   = var.id_token_jwks_url
          claims     = <<-EOF
            {
              "aud": "${var.identity_foundation_app_public_url}",
              "session": {{ .Extra | toJson }}
            }
          EOF
        }
      }
    }
  })
}
