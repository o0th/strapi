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
      http_port   = 3000

      env {
        key   = "URL"
        value = "$${APP_URL}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_HOST"
        value = "$${db.HOSTNAME}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_PORT"
        value = "$${db.PORT}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_NAME"
        value = "$${db.DATABASE}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_USERNAME"
        value = "$${db.USERNAME}"
        scope = "RUN_TIME"
      }

      env {
        key   = "DATABASE_PASSWORD"
        value = "$${db.PASSWORD}"
        scope = "RUN_TIME"
      }

      env {
        key   = "NODE_ENV"
        value = "production"
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
