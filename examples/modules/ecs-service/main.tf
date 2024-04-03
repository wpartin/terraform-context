resource "aws_appautoscaling_target" "this" {
  count = var.enabled && var.enable_autoscaling ? 1 : 0

  max_capacity       = 2
  min_capacity       = 1
  resource_id        = aws_ecs_service.this[count.index].id
  scalable_dimension = "ecs:ServiceCount"
  service_namespace  = var.namespace

  tags = var.tags
}

resource "aws_appautoscaling_policy" "this" {
  count = var.enabled && var.enable_autoscaling ? 1 : 0

  name               = "${aws_ecs_service.this[count.index].name}-scaling-policy"
  resource_id        = aws_appautoscaling_target.this[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.this[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[count.index].service_namespace
}

resource "aws_ecs_service" "this" {
  count = var.enabled ? 1 : 0

  cluster         = var.cluster
  name            = var.name
  task_definition = aws_ecs_task_definition.this[count.index].container_definitions

  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  count = var.enabled ? 1 : 0

  container_definitions = jsonencode([
    {
      name      = var.name
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
  family = var.family

  tags = var.tags
}