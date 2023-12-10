output "function" {
  value = var.enabled ? aws_lambda_function.this[var.name] : null
}

output "s3_object" {
  value = var.enabled ? aws_s3_object.this[var.name] : null
}