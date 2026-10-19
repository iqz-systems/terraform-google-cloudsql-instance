mock_provider "google" {}
mock_provider "random" {}

variables {
  project_id     = "test-project"
  project_region = "us-east1"
  instance_name  = "MyApp"
  suffix         = "Prod"
  machine_tier   = "db-custom-2-7680"
}

run "explicit_inputs" {
  command = plan

  variables {
    edition             = "ENTERPRISE"
    machine_tier        = "db-f1-micro"
    ssl_mode            = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
    authorized_networks = []
  }

  assert {
    condition     = google_sql_database_instance.db_instance.settings[0].tier == "db-f1-micro"
    error_message = "tier was not passed through"
  }

  assert {
    condition     = google_sql_database_instance.db_instance.settings[0].edition == "ENTERPRISE"
    error_message = "edition was not passed through"
  }

  assert {
    condition     = google_sql_database_instance.db_instance.settings[0].ip_configuration[0].ssl_mode == "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
    error_message = "ssl_mode was not passed through"
  }

  assert {
    condition     = google_sql_database_instance.db_instance.settings[0].ip_configuration[0].ipv4_enabled == true
    error_message = "public IPv4 must be enabled"
  }

  assert {
    condition     = length(google_sql_database_instance.db_instance.settings[0].ip_configuration[0].authorized_networks) == 0
    error_message = "authorized_networks should be empty"
  }

  assert {
    condition     = google_sql_database_instance.db_instance.deletion_protection == true
    error_message = "deletion_protection should default to true"
  }

  assert {
    condition     = google_sql_database_instance.db_instance.settings[0].deletion_protection_enabled == true
    error_message = "settings.deletion_protection_enabled should default to true"
  }

  assert {
    condition     = google_sql_database_instance.db_instance.name == "myapp-db-prod"
    error_message = "name should be <instance_name>-db-<suffix>, lowercased"
  }

  assert {
    condition     = google_sql_user.default_user.name == "db_default_user"
    error_message = "default user name should be db_default_user"
  }
}

run "name_without_suffix" {
  command = plan

  variables {
    suffix = ""
  }

  assert {
    condition     = google_sql_database_instance.db_instance.name == "myapp-db"
    error_message = "name should have no trailing dash when suffix is empty"
  }
}

run "deletion_protection_disabled" {
  command = plan

  variables {
    deletion_protection = false
  }

  assert {
    condition     = google_sql_database_instance.db_instance.deletion_protection == false && google_sql_database_instance.db_instance.settings[0].deletion_protection_enabled == false
    error_message = "both deletion protection settings should follow the variable"
  }
}

run "defaults" {
  command = plan

  assert {
    condition     = google_sql_database_instance.db_instance.settings[0].edition == "ENTERPRISE_PLUS"
    error_message = "edition should default to ENTERPRISE_PLUS"
  }

  assert {
    condition     = google_sql_database_instance.db_instance.settings[0].ip_configuration[0].ssl_mode == "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    error_message = "ssl_mode should default to ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  }
}

run "invalid_ssl_mode" {
  command = plan

  variables {
    ssl_mode = "NONE"
  }

  expect_failures = [var.ssl_mode]
}

run "invalid_edition" {
  command = plan

  variables {
    edition = "STANDARD"
  }

  expect_failures = [var.edition]
}

run "database_flags_passed_through" {
  command = plan

  variables {
    database_flags = [
      { name = "max_connections", value = "200" },
      { name = "log_min_duration_statement", value = "500" },
    ]
  }

  assert {
    condition     = length(google_sql_database_instance.db_instance.settings[0].database_flags) == 2
    error_message = "expected two database flags"
  }

  assert {
    condition     = contains([for f in google_sql_database_instance.db_instance.settings[0].database_flags : "${f.name}=${f.value}"], "max_connections=200")
    error_message = "max_connections flag missing"
  }
}
