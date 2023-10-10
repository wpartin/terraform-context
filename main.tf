terraform {
  required_version = ">= 1.5.0, < 2.0.0"
}

locals {
  defaults = {
    label_order = ["env", "team", "region", "namespace", "id", "attributes"]
  }

  regions = {
    us-east-1 = "use1"
    us-east-2 = "use2"
    us-west-1 = "usw1"
    us-west-2 = "usw2"
  }

  context = {
    attributes = local.attributes
    env        = local.env
    id         = local.id
    namespace  = local.namespace
    region     = local.region
    team       = local.team
  }

  attributes = var.attributes != null ? join(local.delimiter, compact(distinct(concat(coalesce(var.attributes, []), coalesce(var.context.attributes, []))))) : null
  delimiter  = var.delimiter != null ? var.delimiter : var.context.delimiter
  enabled    = var.enabled ? var.enabled : var.context.enabled
  env        = var.env != null ? var.env : var.context.env
  id         = var.id != null ? var.id : var.context.id
  namespace  = var.namespace != null ? var.namespace : var.context.namespace
  region     = var.region != null  ? local.regions[var.region] : local.regions[var.context.region]
  team       = var.team != null ? var.team : var.context.team

  id_full    = join(local.delimiter, [ for _, label in local.defaults.label_order : lookup(local.context, label) if lookup(local.context, label) != null ])

  tags = merge(var.tags, var.context.tags, {
    Environment = title(local.env)
    Region      = var.region
    Team        = local.team
  })
}