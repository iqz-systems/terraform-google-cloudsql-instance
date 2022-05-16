output "db_instance_name" {
  value       = google_sql_database_instance.db_instance.name
  description = "The name of the created db instance."
}

output "db_public_ip" {
  value = google_sql_database_instance.db_instance.public_ip_address
}

output "db_instance_connection_name" {
  value       = google_sql_database_instance.db_instance.connection_name
  description = "The connection name of the created db instance."
}

output "default_user" {
  value = google_sql_user.default_user.name
}

output "default_user_password" {
  value     = google_sql_user.default_user.password
  sensitive = true
}
