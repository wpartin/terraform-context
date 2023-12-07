resource "aws_ecs_cluster" "this" {
  count = module.ecs_cluster_label.context.enabled ? 1 : 0

  name = module.ecs_cluster_label.id_full

  tags = module.ecs_cluster_label.context.tags
}

resource "aws_ecs_service" "this" {
  count = module.ecs_service_label.context.enabled ? 1 : 0

  task_definition = aws_ecs_task_definition.this[count.index].container_definitions
  name            = module.ecs_service_label.id_full

  tags = module.ecs_service_label.context.tags
}

resource "aws_ecs_task_definition" "this" {
  count = module.ecs_service_label.context.enabled ? 1 : 0

  container_definitions = jsonencode([
    {
      name      = module.ecs_service_label.id
      image     = "test"
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

  tags = merge(module.ecs_service_label.context.tags, {
    Domain = "SQS"
  })
}

resource "aws_appautoscaling_target" "this" {
  count = module.ecs_service_label.context.enabled ? 1 : 0

  max_capacity       = 2
  min_capacity       = 1
  resource_id        = aws_ecs_service.this[count.index].id
  scalable_dimension = "ecs:ServiceCount"
  service_namespace  = module.ecs_service_label.context.namespace

  tags = module.ecs_service_label.context.tags
}

resource "aws_appautoscaling_policy" "this" {
  count = module.ecs_service_label.context.enabled ? 1 : 0

  name               = "${module.ecs_service_label.id_full}-scaling-policy"
  resource_id        = aws_appautoscaling_target.this[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.this[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[count.index].service_namespace
}