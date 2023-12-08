output "this" {
  value = module.this
}

output "ecs_cluster_label" {
  value = module.ecs_cluster_label
}

output "ecs_service_label" {
  value = module.ecs_service_label
}

output "cluster" {
  value = aws_ecs_cluster.this
}

output "service" {
  value = module.service
}

output "sqs" {
  value = aws_sqs_queue.this
}