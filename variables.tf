variable "project_id" {
  type        = string
  description = "The id of the project where the instance has to be created."
}

variable "project_region" {
  type        = string
  description = "The region where the resources will be created."
}

variable "instance_name" {
  type        = string
  description = "The of the database instance."
}

variable "suffix" {
  type        = string
  default     = ""
  description = "An optional suffix to add to the name of the instance."
}

variable "database_version" {
  type        = string
  default     = "POSTGRES_14"
  description = "The db version that should be deployed in the instance."
}

variable "edition" {
  type        = string
  default     = "ENTERPRISE_PLUS"
  description = "Database instance edition to use. Valid values are 'ENTERPRISE' and 'ENTERPRISE_PLUS'."
  validation {
    condition     = contains(["ENTERPRISE", "ENTERPRISE_PLUS"], var.edition)
    error_message = "Valid values for var: 'ENTERPRISE', 'ENTERPRISE_PLUS'"
  }
}

variable "machine_tier" {
  type        = string
  description = "The machine tier for the database instance."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Set this to false to let terraform delete the instance."
}

variable "authorized_networks" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "ssl_mode" {
  type        = string
  default     = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  description = "Set this to false to allow connections without SSL validation."
  validation {
    condition     = contains(["ALLOW_UNENCRYPTED_AND_ENCRYPTED", "ENCRYPTED_ONLY", "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"], var.ssl_mode)
    error_message = "Valid values for var: 'ALLOW_UNENCRYPTED_AND_ENCRYPTED','ENCRYPTED_ONLY','TRUSTED_CLIENT_CERTIFICATE_REQUIRED'"
  }
}

variable "database_flags" {
  type = list(object({
    name  = string
    value = any
  }))
  default     = []
  description = "The list of database flags to set in the instance. Refer: https://cloud.google.com/sql/docs/postgres/flags"
}

variable "use_special_char_in_password" {
  type        = bool
  default     = false
  description = "If true, the generated default password will contain special characters."
}

variable "override_special" {
  type        = string
  default     = "_()~+-*"
  description = "List of special characters which should be allowed in the database password. Used only if `use_special_char_in_password` is set to `true`."
}

variable "additional_user_labels" {
  type        = any
  default     = {}
  description = "Additional user labels to be attached with the instance."
}

variable "query_insights_enabled" {
  type        = bool
  default     = false
  description = "Set this to true to enable query insights."
  nullable    = true
}

variable "query_plans_per_minute" {
  type        = number
  default     = 5
  description = "The number of query plans to be collected per minute."
  nullable    = true
}

variable "query_string_length" {
  type        = number
  default     = 1024
  description = "The maximum length of the query string."
  nullable    = true
}

variable "record_application_tags" {
  type        = bool
  default     = true
  description = "Set this to true to record application tags."
  nullable    = true
}

variable "record_client_address" {
  type        = bool
  default     = true
  description = "Set this to true to record client address."
  nullable    = true
}
