module "this" {
  source = "../.."

  env       = "sandbox"
  namespace = "ecs"

  tags = {
    Account     = "QA"
    Cost-Center = "Engineering"
    Domain      = "Containers"
    Project     = "Goldenrod"
  }
}

module "ecs_cluster_label" {
  source = "../.."

  id     = "cluster"
  region = "global"

  context = module.this.context
}

module "ecs_service_label" {
  source = "../.."

  id     = "foxtrot"
  region = "us-east-2"
  team   = "butterfly"

  context = module.this.context

  tags = merge(module.this.tags, {
    Cost-Center = "BugsLife"
  })
}