#____________________________________________________________
#
# Power Policy Variables Section.
#____________________________________________________________

variable "description" {
  default     = ""
  description = "Description for the Policy."
  type        = string
}

variable "dynamic_power_rebalancing" {
  default     = "Enabled"
  description = <<-EOT
  Sets the Dynamic Power Rebalancing of the System. This option is only supported for Cisco UCS X series Chassis.
    * Enabled - Set the value to Enabled.
    * Disabled - Set the value to Disabled.
  EOT
  type        = string
}

variable "name" {
  default     = "default"
  description = "Name for the Policy."
  type        = string
}

variable "organization" {
  default     = "default"
  description = "Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "profiles" {
  default     = {}
  description = <<-EOT
  List of Profiles to Assign to the Policy.
    * moid - Managed Object Identifier for the Managed Resource.
    * object_type - Object Type to Assign in the Profile Configuration.
      - chassis.Profile - For UCS Chassis Profiles.
      - server.Profile - For UCS Server Profiles.
      - server.ProfileTemplate - For UCS Server Profile Templates.
  EOT
  type = list(object(
    {
      moid        = string
      object_type = string
    }
  ))
}

variable "power_allocation" {
  default     = 0
  description = "Sets the Allocated Power Budget of the System (in Watts). This field is only supported for Cisco UCS X series Chassis."
  type        = number
}

variable "power_priority" {
  default     = "Low"
  description = <<-EOT
  Sets the Power Priority of the System. This field is only supported for Cisco UCS X series servers.
    * Low - Set the value to Low.
    * Medium - Set the value to Medium.
    * High - Set the value to High.
  EOT
  type        = string
}

variable "power_profiling" {
  default     = "Enabled"
  description = <<-EOT
  Sets the Power Profiling of the Server. This field is only supported for Cisco UCS X series servers.
    * Enabled - Set the value to Enabled.
    * Disabled - Set the value to Disabled.
  EOT
  type        = string
}

variable "power_redunancy" {
  default     = "Grid"
  description = <<-EOT
  Sets the Power Redundancy of the System. N+2 mode is only supported for Cisco UCS X series Chassis.
  * Grid - Grid Mode requires two power sources. If one source fails, the surviving PSUs connected to the other source provides power to the chassis.
  * NotRedundant - Power Manager turns on the minimum number of PSUs required to support chassis power requirements. No Redundant PSUs are maintained.
  * N+1 - Power Manager turns on the minimum number of PSUs required to support chassis power requirements plus one additional PSU for redundancy.
  * N+2 - Power Manager turns on the minimum number of PSUs required to support chassis power requirements plus two additional PSU for redundancy. This Mode is only supported for UCS X series Chassis.
  EOT
  type        = string
}

variable "power_restore" {
  default     = "LastState"
  description = <<-EOT
  Sets the Power Restore State of the Server.
    * AlwaysOff - Set the Power Restore Mode to Off.
    * AlwaysOn - Set the Power Restore Mode to On.
    * LastState - Set the Power Restore Mode to LastState.
  EOT
  type        = string
}

variable "power_save_mode" {
  default     = "Enabled"
  description = <<-EOT
  Sets the Power Save mode of the System. This option is only supported for Cisco UCS X series Chassis.
    * Enabled - Set the value to Enabled.
    * Disabled - Set the value to Disabled.
  EOT
  type        = string
}

variable "tags" {
  default     = []
  description = "List of Tag Attributes to Assign to the Policy."
  type        = list(map(string))
}

