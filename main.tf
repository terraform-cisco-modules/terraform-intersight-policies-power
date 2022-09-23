#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  name = var.organization
}

#____________________________________________________________
#
# Intersight UCS Chassis Profile(s) Data Source
# GUI Location: Profiles > UCS Chassis Profiles > {Name}
#____________________________________________________________

data "intersight_chassis_profile" "profiles" {
  for_each = { for v in local.profiles : v.name => v if v.object_type == "chassis.Profile" }
  name     = each.value.name
}

#____________________________________________________________
#
# Intersight UCS Server Profile(s) Data Source
# GUI Location: Profiles > UCS Server Profiles > {Name}
#____________________________________________________________

data "intersight_server_profile" "profiles" {
  for_each = { for v in local.profiles : v.name => v if v.object_type == "server.Profile" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight UCS Server Profile Template(s) Data Source
# GUI Location: Templates > UCS Server Profile Templates > {Name}
#__________________________________________________________________

data "intersight_server_profile_template" "templates" {
  for_each = { for v in local.profiles : v.name => v if v.object_type == "server.ProfileTemplate" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight Power Policy
# GUI Location: Policies > Create Policy > Power
#__________________________________________________________________

locals {
  profiles = {
    for v in var.profiles : v.name => {
      name        = v.name
      object_type = v.object_type != null ? v.object_type : "server.Profile"
    }
  }
}

resource "intersight_power_policy" "power" {
  depends_on = [
    data.intersight_chassis_profile.profiles,
    data.intersight_server_profile.profiles,
    data.intersight_server_profile_template.templates
  ]
  allocated_budget    = var.power_allocation
  description         = var.description != "" ? var.description : "${var.name} Power Policy."
  name                = var.name
  power_priority      = each.value.power_priority
  power_profiling     = each.value.power_profiling
  power_restore_state = each.value.power_restore
  power_save_mode     = each.value.power_save_mode
  redundancy_mode     = each.value.power_redunancy
  organization {
    moid        = data.intersight_organization_organization.org_moid.results[0].moid
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = local.profiles
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