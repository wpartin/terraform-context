resource "null_resource" "binary" {
  for_each = local.enabled

  provisioner "local-exec" {
    command = "GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOFLAGS=-trimpath go build -mod=readonly -ldflags='-s -w' -o ${local.binary_path}"
  }
}

data "archive_file" "this" {
  for_each = local.enabled

  type        = "Zip"
  source_file = "${path.root}/${each.value}"
  output_path = "."

  depends_on = [local.binary_name]
}

data "aws_iam_policy_document" "assume_lambda_role" {
  for_each = local.enabled

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "allow_lambda_logging" {
  for_each = local.enabled

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}