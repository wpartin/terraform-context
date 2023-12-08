resource "aws_ecs_cluster" "this" {
  count = module.ecs_cluster_label.enabled ? 1 : 0

  name = module.ecs_cluster_label.id_full

  tags = module.ecs_cluster_label.tags
}

module "service" {
  source = "../modules/ecs-service"

  cluster            = aws_ecs_cluster.this[0].name
  enabled            = module.ecs_service_label.enabled
  enable_autoscaling = true
  family             = module.ecs_service_label.id
  name               = module.ecs_service_label.id_full
  namespace          = module.ecs_service_label.namespace

  tags    = module.ecs_service_label.tags
}