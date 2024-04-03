output "context" {
  value = module.context.enabled ? module.context : null
}