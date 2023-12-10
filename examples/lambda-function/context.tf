module "this" {
  source = "../.."

  env       = "sandbox"
  namespace = "lambda"

  tags = {
    Account     = "Sandbox"
    Domain      = "CostOptimization"
    Environment = "Sandbox"
  }
}

module "lambda_label" {
  source = "../.."

  context = module.this.context
  id      = "cost-optimizer"
  region  = "us-west-1"
  team    = "hammertime"
}