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
