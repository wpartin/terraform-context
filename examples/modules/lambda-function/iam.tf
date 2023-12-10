resource "aws_iam_role" "this" {
  for_each = local.enabled

  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role[var.name].json
  description        = "Role for lambda to assume lambda"
  name               = "AssumeLambdaRole"
}

resource "aws_iam_policy" "this" {
  for_each = local.enabled

  description = "Policy for lambda cloudwatch logging"
  name        = "AllowLambdaLoggingPolicy"
  policy      = data.aws_iam_policy_document.allow_lambda_logging[var.name].json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.enabled

  policy_arn = aws_iam_policy.this[var.name].arn
  role       = aws_iam_role.this[var.name].id
}