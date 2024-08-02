resource "google_sql_database_instance" "db_instance" {
  name = lower("${var.instance_name}-db${var.suffix == "" ? "" : join("", ["-", var.suffix])}")

  project = var.project_id
  region  = var.project_region

  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier            = var.machine_tier
    disk_autoresize = true
    disk_size       = 20
    disk_type       = "PD_SSD"

    deletion_protection_enabled = var.deletion_protection

    user_labels = merge({
      "project" = var.project_id
    }, var.additional_user_labels)

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value["name"]
        value = database_flags.value["value"]
      }
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "06:00" # 6 AM in the region
      point_in_time_recovery_enabled = true
      location                       = var.project_region
      backup_retention_settings {
        retained_backups = 30
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled = true
      ssl_mode     = var.ssl_mode

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value["name"]
          value = authorized_networks.value["value"]
        }
      }
    }

    insights_config {
      query_insights_enabled  = var.query_insights_enabled
      query_string_length     = var.query_string_length
      record_application_tags = var.record_application_tags
      record_client_address   = var.record_client_address
      query_plans_per_minute  = var.query_plans_per_minute
    }

    maintenance_window {
      day          = 7 # Sunday
      hour         = 4 # 4 AM
      update_track = "stable"
    }
  }

  lifecycle {
    ignore_changes = [
      settings.0.disk_size
    ]
  }
}

resource "random_password" "default_user_password" {
  length           = 64
  upper            = true
  lower            = true
  numeric          = true
  special          = var.use_special_char_in_password
  override_special = var.override_special

  keepers = {
    user_name = "db_default_user"
  }
}

resource "google_sql_user" "default_user" {
  name     = random_password.default_user_password.keepers.user_name
  instance = google_sql_database_instance.db_instance.name
  password = random_password.default_user_password.result
  project  = var.project_id
}
