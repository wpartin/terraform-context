output "delimiter" {
  description = "The delimiter selected."
  value       = var.delimiter
}

output "enabled" {
  description = "Enable / disable labels or the root module as a whole."
  value       = var.enabled
}

output "environment" {
  description = "The environment selected."
  value       = var.environment
}

output "id" {
  description = "The id for the resource(s) as configured by the label."
  value       = var.id
}

output "labels" {
  description = "value"
  value       = local.finalized_labels
}

output "namespace" {
  description = "The appropriate namespace for the resource(s)."
  value       = var.namespace
}

output "region" {
  description = "The AWS region to deploy resources into."
  value       = var.region
}

output "tags" {
  description = "The tags compiled by the label."
  value       = var.tags
}