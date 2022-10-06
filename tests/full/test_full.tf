terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
}

# Setup provider, variables and outputs
provider "intersight" {
  apikey    = var.intersight_keyid
  secretkey = file(var.intersight_secretkeyfile)
  endpoint  = var.intersight_endpoint
}

variable "intersight_keyid" {}
variable "intersight_secretkeyfile" {}
variable "intersight_endpoint" {
  default = "intersight.com"
}
variable "name" {}

output "moid" {
  value = module.main.moid
}

# This is the module under test
module "main" {
  source                    = "../.."
  description               = "${var.name} Power Policy."
  dynamic_power_rebalancing = "Enabled"
  extended_power_capacity   = "Enabled"
  name                      = var.name
  organization              = "terratest"
  power_allocation          = 8400
  power_priority            = "Low"
  power_profiling           = "Enabled"
  power_redundancy          = "Grid"
  power_restore             = "LastState"
  power_save_mode           = "Enabled"
}
