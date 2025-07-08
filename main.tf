terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=6.42.0"
    }
  }
}

data "google_project" "current" {
}
