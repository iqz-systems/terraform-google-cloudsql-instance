terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=6.42.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}
