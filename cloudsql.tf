resource "google_sql_database_instance" "db_instance" {
  name    = lower("${var.instance_name}-db${var.suffix == "" ? "" : "-" + var.suffix}")
  project = var.project_id
  region  = var.project_region

  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier            = var.machine_tier
    disk_autoresize = true
    disk_size       = 20
    disk_type       = "PD_SSD"

    user_labels = {
      "project" = var.project_id
    }

    database_flags {
      name  = "max_connections"
      value = "150"
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
      require_ssl  = var.require_ssl

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value["name"]
          value = authorized_networks.value["value"]
        }
      }
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
  special          = true
  override_special = "_%()@!~+-*"

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
