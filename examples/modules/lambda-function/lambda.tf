resource "aws_lambda_function" "this" {
  for_each = local.enabled

  description       = var.description
  function_name     = var.name
  handler           = var.name
  memory_size       = var.memory
  package_type      = "Zip"
  role              = var.role
  runtime           = var.runtime
  s3_bucket         = aws_s3_object.this[var.name].bucket
  s3_key            = aws_s3_object.this[var.name].key
  s3_object_version = aws_s3_object.this[var.name].version_id

  tags = var.tags
}