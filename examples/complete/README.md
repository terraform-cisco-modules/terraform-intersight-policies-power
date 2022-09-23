<!-- BEGIN_TF_DOCS -->
# Power Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

### main.tf
```hcl
module "power_policy" {
  source  = "terraform-cisco-modules/policies-power/intersight"
  version = ">= 1.0.1"

  description               = "default Power Policy."
  power_allocation          = "8400"
  power_priority            = "Low"
  power_profiling           = "Enabled"
  power_redundancy          = "Grid"
  power_restore             = "LastState"
  power_save_mode           = "Enabled"
  dynamic_power_rebalancing = "Enabled"
  name                      = "default"
  organization              = "default"
}

```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}
```

### versions.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = var.secretkey
}
```
<!-- END_TF_DOCS -->