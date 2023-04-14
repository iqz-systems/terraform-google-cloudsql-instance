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
