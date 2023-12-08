resource "aws_ecs_cluster" "this" {
  count = module.ecs_cluster_label.context.enabled ? 1 : 0

  name = module.ecs_cluster_label.id_full

  tags = module.ecs_cluster_label.context.tags
}

module "service" {
  source = "./modules/ecs-service"

  cluster            = aws_ecs_cluster.this[0].name
  enabled            = module.ecs_service_label.enabled
  enable_autoscaling = true
  family             = module.ecs_service_label.id
  name               = module.ecs_service_label.id_full
  namespace          = module.ecs_service_label.namespace

  tags    = module.ecs_service_label.context.tags
}

resource "aws_sqs_queue" "this" {
  count = module.ecs_service_label.context.enabled ? 1 : 0

  name = replace(module.ecs_service_label.id_full, "ecs", "sqs")

  tags = merge(module.ecs_service_label.context.tags, {
    Domain = "SQS"
  })
}

output "this" {
  value = module.this
}

output "ecs_cluster_label" {
  value = module.ecs_cluster_label
}

output "ecs_service_label" {
  value = module.ecs_service_label
}