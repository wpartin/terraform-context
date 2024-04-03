resource "aws_sqs_queue" "this" {
  for_each = { for label, attributes in module.context.labels : replace(attributes.id_full, "ecs", "sqs") => attributes if attributes.enabled && label == "ecs_service" }

  name = each.key

  tags = merge(module.context.labels.ecs_service.tags, {
    Domain = "SQS"
  })
}