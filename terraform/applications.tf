resource "random_string" "app_keys" {
  length  = 64
  special = false
}

resource "random_string" "token_salt" {
  length  = 64
  special = false
}

resource "random_string" "jwt_secret" {
  length  = 64
  special = false
}

resource "random_string" "jwt_admin_secret" {
  length  = 64
  special = false
}

resource "digitalocean_app" "dev_strapi" {
  spec {
    name   = "dev-strapi"
    region = "fra"

    service {
      name = "dev-strapi-service"

      environment_slug = "node-js"

      instance_count     = 1
      instance_size_slug = "basic-xxs"

      run_command = "npm start"
      http_port   = 1337

      env {
        key   = "URL"
        value = "$${PUBLIC_URL}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_HOST"
        value = "$${dev-strapi-database.HOSTNAME}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_PORT"
        value = "$${dev-strapi-database.PORT}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_NAME"
        value = "$${dev-strapi-database.DATABASE}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_USERNAME"
        value = "$${dev-strapi-database.USERNAME}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_PASSWORD"
        value = "$${dev-strapi-database.PASSWORD}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_CA"
        value = "$${dev-strapi-database.CA_CERT}"
        scope = "RUN_TIME"
      }

      env {
        key   = "NODE_ENV"
        value = "production"
        scope = "RUN_TIME"
      }

      env {
        key   = "APP_KEYS"
        value = random_string.app_keys.result
        scope = "RUN_TIME"
      }

      env {
        key   = "API_TOKEN_SALT"
        value = random_string.token_salt.result
        scope = "RUN_TIME"
      }

      env {
        key   = "ADMIN_JWT_SECRET"
        value = random_string.jwt_admin_secret.result
        scope = "RUN_TIME"
      }

      env {
        key   = "JWT_SECRET"
        value = random_string.jwt_secret.result
        scope = "RUN_TIME"
      }

      github {
        repo   = "o0th/strapi"
        branch = "master"

        deploy_on_push = true
      }

      health_check {
        http_path             = "/"
        success_threshold     = 3
        failure_threshold     = 3
        initial_delay_seconds = 1
        period_seconds        = 1
        timeout_seconds       = 1
      }
    }

    database {
      name       = "dev-strapi-database"
      engine     = "PG"
      production = false
    }
  }
}
