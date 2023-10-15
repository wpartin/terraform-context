resource "aws_ecs_cluster" "this" {
  count = module.ecs_cluster_label.context.enabled ? 1 : 0

  name = module.ecs_cluster_label.id_full

  tags = module.ecs_cluster_label.context.tags
}

resource "aws_ecs_service" "this" {
  count = module.ecs_service_label.context.enabled ? 1 : 0

  task_definition = aws_ecs_task_definition.this[count.index].container_definitions
  name = module.ecs_service_label.id_full

  tags = module.ecs_service_label.context.tags
}

resource "aws_ecs_task_definition" "this" {
  count = module.ecs_service_label.context.enabled ? 1 : 0

  container_definitions = jsonencode([
    {
      name      = module.ecs_service_label.id
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }])
  family = module.ecs_service_label.id

  tags = module.ecs_service_label.context.tags
}

resource "aws_sqs_queue" "this" {
  count = module.ecs_service_label.context.enabled ? 1 : 0

  name = replace(module.ecs_service_label.id_full, "ecs", "sqs")

  tags = module.ecs_service_label.context.tags
}