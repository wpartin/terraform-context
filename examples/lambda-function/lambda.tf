module "lambda" {
  source = "../modules/lambda-function"

  description      = "my lambda"
  enabled          = module.lambda_label.enabled
  memory           = 128
  name             = module.lambda_label.id_full
  role             = "arn:aws:iam::account:role/role-name-with-path"
  runtime          = "go1.x"
  source_file_name = "hello-world.go"
  team             = "squirrel"

  tags = module.lambda_label.tags
}