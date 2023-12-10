locals {
  enabled     = var.enabled ? toset([for name in [var.name] : name]) : []
  binary_name = var.enabled ? null_resource.binary[var.name] : null
  binary_path = path.root
}