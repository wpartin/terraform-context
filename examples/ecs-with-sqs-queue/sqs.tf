resource "aws_sqs_queue" "this" {
  count = module.ecs_service_label.enabled ? 1 : 0

  name = replace(module.ecs_service_label.id_full, "ecs", "sqs")

  tags = merge(module.ecs_service_label.tags, {
    Domain = "SQS"
  })
}