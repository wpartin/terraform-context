output "context" {
  description = "The output context that can be passed around with other lables. The root context can be accessed with: \"module.this.context\"."
  value       = local.input
}

output "enabled" {
  description = "Enable / disable labels or the root module as a whole."
  value       = var.enabled
}

output "id" {
  description = "The id for the resource(s) as configured by the label."
  value       = var.id
}

output "id_full" {
  description = "The full id for the resource(s) as configured by the label; includes any labels included in \"var.label_order\"."
  value       = local.id_full
}

output "region" {
  description = "The AWS region to deploy resources into."
  value       = var.region
}

output "tags" {
  description = "The tags compiled by the label."
  value       = local.input.tags
}