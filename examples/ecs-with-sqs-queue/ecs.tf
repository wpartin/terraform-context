resource "aws_ecs_cluster" "this" {
  for_each = { for label, attributes in module.context.labels : attributes.id_full => attributes if attributes.enabled && label == "ecs_cluster" }

  name = each.key

  tags = each.value.tags
}

module "ecs_service" {
  source = "../modules/ecs-service"

  for_each = { for label, attributes in module.context.labels : attributes.id_full => attributes if attributes.enabled && label == "ecs_service" }

  cluster            = coalesce(var.cluster, lookup(aws_ecs_cluster.this, module.context.labels.ecs_cluster.id_full).name)
  enabled            = each.value.enabled
  enable_autoscaling = true
  family             = each.value.id
  name               = each.value.id_full
  namespace          = each.value.namespace

  tags = each.value.tags
}

variable "cluster" {
  description = "The ECS cluster identifier."
  type        = string
  default     = null
}