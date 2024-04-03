terraform {
  required_version = ">= 1.5.0, < 2.0.0"
}

locals {
  initialized_labels = {
    for label, configuration in var.labels : label => {
      enabled         = coalesce(configuration.enabled, var.enabled)
      environment     = var.environment
      id              = coalesce(configuration.id, var.id)
      id_length_limit = coalesce(configuration.id_length_limit, var.id_length_limit)
      label_order     = coalesce(configuration.label_order, var.label_order)
      namespace       = coalesce(configuration.namespace, var.namespace)
      region          = lookup(local.regions, coalesce(configuration.region, var.region))
      unit            = try(configuration.unit, var.unit, "")
      tags            = merge(var.tags, try(configuration.tags, {}))
    }
  }

  finalized_labels = {
    for label, configuration in local.initialized_labels : label => merge(configuration, {
      // I would like a better way to handle this rather than duplicating the underlying loops here
      id_full  = join(var.delimiter, [for _, label in configuration.label_order : lookup(configuration, label) if lookup(configuration, label) != null])
      id_short = join(var.delimiter, slice([for _, label in configuration.label_order : lookup(configuration, label) if lookup(configuration, label) != null], 0, configuration.id_length_limit))
    })
  }

  regions = {
    global    = "glb"
    us-east-1 = "use1"
    us-east-2 = "use2"
    us-west-1 = "usw1"
    us-west-2 = "usw2"
  }
}