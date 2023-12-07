## Usage

```hcl
### context.tf ###
module "this" {
  source = "..."

  enabled   = true
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
  source = "..."

  id     = "cluster"
  region = "global"

  context = module.this.context
}

module "ecs_service_label" {
  source = "..."

  enabled = false
  id     = "foxtrot"
  region = "us-east-2"
  team   = "butterfly"

  context = module.this.context

  tags = merge(module.this.tags, {
    Cost-Center = "BugsLife"
  })
}

### test.tf ###
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
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version            |
|------|--------------------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | \>= 1.5.0, < 2.0.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | A "context" object to pass around between modules. The "this" module contains the "root context" which can be updated by other labels using "module.this.context". | `any` | `null` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | The delimiter to use for separating the ID string components. Either - or \_ | `string` | `"-"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable / Disable the module. | `bool` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment identifier. | `string` | `null` | no |
| <a name="input_id"></a> [id](#input\_id) | The name for the resource(s). | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | The maximum length of an id when combining the appropriate labels. | `number` | `3` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order that the resource labels should be in. | `list(string)` | <pre>[<br>  "env",<br>  "region",<br>  "team",<br>  "namespace",<br>  "id"<br>]</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace that the resource belongs to. Example: "ecs" | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources into. Valid choices are: "global, us-east-1, us-east-2, us-west-1, us-west-2." Will be modified to a short id for resource names. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the resources. Set global tag values in the "this" version of the module, and then pass label specific modifications to "module.this.context". | `map(string)` | `null` | no |
| <a name="input_team"></a> [team](#input\_team) | The team identifier that the resources are for. Should be a short-hand identifier. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_context"></a> [context](#output\_context) | The output context that can be passed around with other lables. The root context can be accessed with: "module.this.context". |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Enable / disable labels or the root module as a whole. |
| <a name="output_id"></a> [id](#output\_id) | The id for the resource(s) as configured by the label. |
| <a name="output_id_full"></a> [id\_full](#output\_id\_full) | The full id for the resource(s) as configured by the label; includes any labels included in "var.label\_order". |
| <a name="output_region"></a> [region](#output\_region) | The AWS region to deploy resources into. |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags compiled by the label. |
<!-- END_TF_DOCS -->