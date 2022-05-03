resource "local_file" "oathkeeper_access_rules" {
  filename = "${path.module}/access-rules.json"
  content = jsonencode([
    {
      id = "ory:account"
      upstream = {
        url = var.identity_foundation_account_public_url
      }
      match = {
        url = "${var.oathkeeper_proxy_public_url}/<{auth,auth/**}>"
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
      id = "ory:app"
      upstream = {
        url = var.identity_foundation_app_public_url
      }
      match = {
        url = "${var.oathkeeper_proxy_public_url}/<{app,app/home,app/favicon.ico,app/_next/static/**.css,app/_next/static/**.js,app/**.svg}>",
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
      id = "ory:apis:app"
      upstream = {
        url        = "${var.identity_foundation_apis_public_url}/app/api"
        strip_path = "/apis/app"
      }
      match = {
        url = "${var.oathkeeper_proxy_public_url}/apis/app/<**>"
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
          handler = "json"
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
            to = "${var.oathkeeper_proxy_public_url}/auth/login.php?redirect=${var.oathkeeper_proxy_public_url}/app/home"
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
          check_session_url = "${var.oathkeeper_proxy_public_url}/auth/whoami.php"
          extra_from        = "@this"
          preserve_path     = true
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
