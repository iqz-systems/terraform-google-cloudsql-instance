# terraform-google-cloudsql-instance

Terraform module to create a non-HA CloudSQL instance with meaningful defaults.

This module uses the [google](https://registry.terraform.io/providers/hashicorp/google) and [random](https://registry.terraform.io/providers/hashicorp/random) providers.

## Usage

```hcl
module "db_instance" {
  source  = "iqz-systems/cloudsql-instance/google"
  version = "3.1.1"

  project_id     = "myproject"
  project_region = "us-east1"

  instance_name                = "mydbinstance"
  suffix                       = ""
  database_version             = "POSTGRES_14"
  edition                      = "ENTERPRISE_PLUS"
  machine_tier                 = "db-perf-optimized-N-2"
  deletion_protection          = true
  ssl_mode                     = "ENCRYPTED_ONLY"
  authorized_networks          = []
  database_flags               = []
  use_special_char_in_password = false
  additional_user_labels = {
    environment = "production"
  }
}
```

The shared-core tiers such as `db-f1-micro` and `db-g1-small` are only available in the `ENTERPRISE` edition, so set `edition = "ENTERPRISE"` when using one of them. The default edition is `ENTERPRISE_PLUS`.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `project_id` | `string` | n/a (required) | The id of the project where the instance has to be created. |
| `project_region` | `string` | n/a (required) | The region where the resources will be created. |
| `instance_name` | `string` | n/a (required) | The name of the database instance. The created instance is named `<instance_name>-db[-<suffix>]`, lowercased. |
| `suffix` | `string` | `""` | An optional suffix to add to the name of the instance. |
| `database_version` | `string` | `"POSTGRES_14"` | The db version that should be deployed in the instance. |
| `edition` | `string` | `"ENTERPRISE_PLUS"` | Database instance edition to use. Valid values are `ENTERPRISE` and `ENTERPRISE_PLUS`. |
| `machine_tier` | `string` | n/a (required) | The machine tier for the database instance. |
| `deletion_protection` | `bool` | `true` | Set this to false to let terraform delete the instance. Also sets the instance level deletion protection. |
| `authorized_networks` | `list(object({ name = string, value = string }))` | `[]` | The list of networks (name and CIDR value) that are allowed to connect to the instance over its public IP. |
| `ssl_mode` | `string` | `"ALLOW_UNENCRYPTED_AND_ENCRYPTED"` | The SSL mode of the public IP. Valid values are `ALLOW_UNENCRYPTED_AND_ENCRYPTED` (SSL is optional), `ENCRYPTED_ONLY` (SSL is required, client certificates are not) and `TRUSTED_CLIENT_CERTIFICATE_REQUIRED` (SSL with a trusted client certificate is required). |
| `database_flags` | `list(object({ name = string, value = any }))` | `[]` | The list of database flags to set in the instance. Refer: https://cloud.google.com/sql/docs/postgres/flags |
| `use_special_char_in_password` | `bool` | `false` | If true, the generated default password will contain special characters. |
| `override_special` | `string` | `"_()~+-*"` | List of special characters which should be allowed in the database password. Used only if `use_special_char_in_password` is set to `true`. |
| `additional_user_labels` | `any` | `{}` | Additional user labels to be attached with the instance. The label `project` is always set to the project id. |
| `query_insights_enabled` | `bool` | `false` | Set this to true to enable query insights. |
| `query_plans_per_minute` | `number` | `5` | The number of query plans to be collected per minute. |
| `query_string_length` | `number` | `1024` | The maximum length of the query string. |
| `record_application_tags` | `bool` | `true` | Set this to true to record application tags. |
| `record_client_address` | `bool` | `true` | Set this to true to record client address. |

## Outputs

| Name | Description |
|---|---|
| `db_instance_name` | The name of the created db instance. |
| `db_public_ip` | The public IPv4 address of the db instance. |
| `db_instance_connection_name` | The connection name of the created db instance. |
| `default_user` | The name of the default database user (`db_default_user`). |
| `default_user_password` | The generated password of the default database user (sensitive). |

## Fixed settings

The following settings are not configurable through input variables:

- The disk is 20 GB of `PD_SSD` with automatic disk resize enabled, and changes to the disk size are ignored by Terraform.
- Automated backups run at 06:00 with point-in-time recovery enabled, and 30 backups are retained.
- The maintenance window is Sunday at 04:00 on the `stable` update track.
- The public IPv4 address is enabled.
- The instance is a single-zone (non-HA) instance.

## Links

- [Terraform registry](https://registry.terraform.io/modules/iqz-systems/cloudsql-instance/google/latest)
