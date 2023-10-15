terraform {
  required_version = ">= 1.5.0, < 2.0.0"
}

locals {
  defaults = {
    delimiter       = "-"
    id_length_limit = 3
    label_order     = ["env", "region", "team", "namespace", "id"]
  }

  id_length_limit = var.id_length_limit != null ? var.id_length_limit : var.context != null ? try(var.context.id_length_limit, local.defaults.id_length_limit) : local.defaults.id_length_limit
  id_full         = join(local.input.delimiter, [for _, label in local.defaults.label_order : lookup(local.input, label) if lookup(local.input, label) != null])
  id_short        = slice(split(local.input.delimiter, local.id_full), 0, local.id_length_limit)

  regions = {
    global    = "glb"
    us-east-1 = "use1"
    us-east-2 = "use2"
    us-west-1 = "usw1"
    us-west-2 = "usw2"
  }

  input = {
    delimiter  = var.delimiter != null ? var.delimiter : try(var.context.delimiter, local.defaults.delimiter)
    enabled    = var.enabled ? var.enabled : try(var.context.enabled, false)
    env        = var.env != null ? var.env : try(var.context.env, "")
    id         = var.id != null ? var.id : try(var.context.id, "")
    namespace  = var.namespace != null ? var.namespace : try(var.context.namespace, "")
    region     = var.region != null ? lookup(local.regions, var.region) : try(var.context.region, "")
    tags       = merge(try(var.context.tags, {}), try(var.tags, {}))
    team       = var.team != null ? var.team : try(var.context.team, "")
  }
}