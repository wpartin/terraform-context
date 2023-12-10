resource "random_pet" "this" {
  for_each = local.enabled

  length = 4
}

resource "aws_s3_bucket" "this" {
  for_each = local.enabled

  bucket = random_pet.this[var.name].id
}

resource "aws_s3_object" "this" {
  for_each = local.enabled

  bucket = aws_s3_bucket.this[var.name].bucket
  key    = "${var.team}/lambdas/${var.name}"
}