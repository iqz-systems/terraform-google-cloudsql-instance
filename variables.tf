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

variable "require_ssl" {
  type        = bool
  default     = true
  description = "Set this to false to allow connections without SSL validation."
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
