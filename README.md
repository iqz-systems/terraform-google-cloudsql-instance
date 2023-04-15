# terraform-google-cloudsql-instance

Terraform module to create a non-HA CloudSQL instance with meaningful defaults.

This module uses the [google](https://registry.terraform.io/providers/hashicorp/google) provider.

## Usage

```hcl
module "db_instance" {
  source = "iqz-systems/cloudsql-instance/google"

  project_id     = "myproject"
  project_region = "us-east1"

  instance_name                = "mydbinstance"
  suffix                       = ""
  database_version             = "POSTGRES_14"
  machine_tier                 = "db-custom-2-7680"
  deletion_protection          = true
  authorized_networks          = []
  require_ssl                  = true
  database_flags               = []
  use_special_char_in_password = false
  additional_user_labels = {
    environment = "production"
  }
}
```

## Links

- [Terraform registry](https://registry.terraform.io/modules/iqz-systems/cloudsql-instance/google/latest)
