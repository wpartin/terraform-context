output "context" {
  description = <<-EOT
    This outputs the contextual values related to logically grouped resources.
    It will help to define a consistent naming and tagging convention for
    these resources as well. The following values are exported:
    attributes, delimiter, env, id, namespace, region, team, and tags.
  EOT
  value = {
    attributes = local.attributes
    delimiter  = local.delimiter
    enabled    = local.enabled
    env        = local.env
    id         = local.id_full
    namespace  = local.namespace
    region     = var.region
    team       = local.team
    tags       = local.tags
  }
}

output "enabled" {
  value = local.enabled
}