#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  for_each = {
    for v in [var.organization] : v => v if length(
      regexall("[[:xdigit:]]{24}", var.organization)
    ) == 0
  }
  name = each.value
}

#____________________________________________________________
#
# Intersight UCS Chassis Profile(s) Data Source
# GUI Location: Profiles > UCS Chassis Profiles > {Name}
#____________________________________________________________

data "intersight_chassis_profile" "profiles" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "chassis.Profile" }
  name     = each.value.name
}

#____________________________________________________________
#
# Intersight UCS Server Profile(s) Data Source
# GUI Location: Profiles > UCS Server Profiles > {Name}
#____________________________________________________________

data "intersight_server_profile" "profiles" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "server.Profile" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight UCS Server Profile Template(s) Data Source
# GUI Location: Templates > UCS Server Profile Templates > {Name}
#__________________________________________________________________

data "intersight_server_profile_template" "templates" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "server.ProfileTemplate" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight Power Policy
# GUI Location: Policies > Create Policy > Power
#__________________________________________________________________

resource "intersight_power_policy" "power" {
  depends_on = [
    data.intersight_chassis_profile.profiles,
    data.intersight_server_profile.profiles,
    data.intersight_server_profile_template.templates
  ]
  allocated_budget        = var.power_allocation
  description             = var.description != "" ? var.description : "${var.name} Power Policy."
  dynamic_rebalancing     = var.dynamic_power_rebalancing
  extended_power_capacity = var.extended_power_capacity
  name                    = var.name
  power_priority          = var.power_priority
  power_profiling         = var.power_profiling
  power_restore_state     = var.power_restore
  power_save_mode         = var.power_save_mode
  redundancy_mode         = var.power_redundancy
  organization {
    moid = length(
      regexall("[[:xdigit:]]{24}", var.organization)
      ) > 0 ? var.organization : data.intersight_organization_organization.org_moid[
      var.organization].results[0
    ].moid
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = { for v in var.profiles : v.name => v }
    content {
      moid = length(regexall("chassis.Profile", profiles.value.object_type)
        ) > 0 ? data.intersight_chassis_profile.templates[profiles.value.name].results[0
        ].moid : length(regexall("server.ProfileTemplate", profiles.value.object_type)
        ) > 0 ? data.intersight_server_profile_template.templates[profiles.value.name].results[0
      ].moid : data.intersight_server_profile.profiles[profiles.value.name].results[0].moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
