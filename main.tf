terraform {
  required_version = ">= 1.5.0, < 2.0.0"
}

locals {
  id_length_limit = try(var.context.id_length_limit, var.id_length_limit)
  id_full         = join(local.input.delimiter, [for _, label in var.label_order : lookup(local.input, label) if lookup(local.input, label) != null])
  id_short        = slice(split(local.input.delimiter, local.id_full), 0, local.id_length_limit)

  regions = {
    global    = "glb"
    us-east-1 = "use1"
    us-east-2 = "use2"
    us-west-1 = "usw1"
    us-west-2 = "usw2"
  }

  input = {
    delimiter  = coalesce(var.delimiter, var.context.delimiter)
    enabled    = var.enabled ? var.context.enabled : var.enabled
    env        = var.env == null ? var.context.env : var.env
    id         = try(var.id, var.context.id, "")
    namespace  = coalesce(var.namespace, var.context.namespace, "")
    region     = var.region != null ? lookup(local.regions, var.region) : try(var.context.region, null)
    tags       = merge(try(var.context.tags, {}), try(var.tags, {}))
    team       = try(var.team, var.context.team, "")
  }
}