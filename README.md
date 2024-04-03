## Introduction

This module aims to assist in making resource naming and tagging across root modules more consistent and easier to manage.
To instantiate this module for use, first create a `this` version of the module that will create your base `context` object.
The `context` object gets passed around and can be modified in any subsequent `label` modules as needed. When instantiating
a resource, use a for_each with the shown syntax style where possible. This will keep dynamic creation possible by changing
either the context's enabled variable, or a label's, while maintaining readability.

## Usage

```go
### context.tf ###
module "context" {
  source = "../.."

  environment = "testing"
  namespace   = "ecs"

  labels = {
    ecs_cluster = {
      id     = "cluster"
      region = "global"
    }
    ecs_service = {
      id     = "foxtrot"
      region = "us-east-2"
      unit   = "butterfly"
    }
  }

  tags = {
    IsTerraformed  = true
    Environment    = "Testing"
    Unit           = "Containers"
  }
}

### ecs.tf ###
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

### sqs.tf ###
resource "aws_sqs_queue" "this" {
  for_each = { for label, attributes in module.context.labels : replace(attributes.id_full, "ecs", "sqs") => attributes if attributes.enabled && label == "ecs_service" }

  name = each.key

  tags = merge(module.context.labels.ecs_service.tags, {
    Domain = "SQS"
  })
}

### example of context outputs ###
Changes to Outputs:
context = {
  delimiter   = "-"
  enabled     = true
  environment = "testing"
  id          = null
  labels      = {
    ecs_cluster = {
      enabled         = true
      environment     = "testing"
      id              = "cluster"
      id_full         = "testing-glb-ecs-cluster"
      id_short        = "testing-glb-ecs"
      id_length_limit = 3
      id_short        =
      label_order     = [
        "environment",
        "region",
        "unit",
        "namespace",
        "id",
      ]
      namespace       = "ecs"
      region          = "glb"
      tags            = {
        Environment   = "Testing"
        IsTerraformed = "true"
        Unit          = "Containers"
      }
      unit            = null
    }
    ecs_service = {
      enabled         = true
      environment     = "testing"
      id              = "foxtrot"
      id_full         = "testing-use2-butterfly-ecs-foxtrot"
      id_short        = "testing-use2-butterfly"
      id_length_limit = 3
      label_order     = [
        "environment",
        "region",
        "unit",
        "namespace",
        "id",
      ]
      namespace       = "ecs"
      region          = "use2"
      tags            = {
        Environment   = "Testing"
        IsTerraformed = "true"
        Unit          = "Containers"
      }
      unit            = "butterfly"
    }
  }
  namespace   = "ecs"
  region      = "us-west-1"
  tags        = {
    Environment   = "Testing"
    IsTerraformed = "true"
    Unit          = "Containers"
  }
}
```

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version           |
| ------------------------------------------------------------------------ | ----------------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.5.0, < 2.0.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name                                                                           | Description                                                                                                                                                              | Type                                                                                                                                                                                                                                                                                     | Default                                                                                  | Required |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | :------: |
| <a name="input_delimiter"></a> [delimiter](#input_delimiter)                   | The delimiter to use for separating the ID string components. Either - or \_                                                                                             | `string`                                                                                                                                                                                                                                                                                 | `"-"`                                                                                    |    no    |
| <a name="input_enabled"></a> [enabled](#input_enabled)                         | Enable / Disable the module.                                                                                                                                             | `bool`                                                                                                                                                                                                                                                                                   | `true`                                                                                   |    no    |
| <a name="input_environment"></a> [environment](#input_environment)             | The environment identifier.                                                                                                                                              | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                                   |    no    |
| <a name="input_id"></a> [id](#input_id)                                        | The name for the resource(s).                                                                                                                                            | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                                   |    no    |
| <a name="input_id_length_limit"></a> [id_length_limit](#input_id_length_limit) | The maximum length of an id when combining the appropriate labels.                                                                                                       | `number`                                                                                                                                                                                                                                                                                 | `6`                                                                                      |    no    |
| <a name="input_label_order"></a> [label_order](#input_label_order)             | The order that the resource labels should be in.                                                                                                                         | `list(string)`                                                                                                                                                                                                                                                                           | <pre>[<br> "environment",<br> "region",<br> "unit",<br> "namespace",<br> "id"<br>]</pre> |    no    |
| <a name="input_labels"></a> [labels](#input_labels)                            | A map of objects that will define any desired labels.                                                                                                                    | <pre>map(object({<br> enabled = optional(bool)<br> id = string<br> id_length_limit = optional(number)<br> label_order = optional(list(string))<br> namespace = optional(string)<br> region = optional(string)<br> unit = optional(string)<br> tags = optional(map(string))<br> }))</pre> | n/a                                                                                      |   yes    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                   | The namespace that the resource belongs to. Example: "ecs"                                                                                                               | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                                     |    no    |
| <a name="input_region"></a> [region](#input_region)                            | The AWS region to deploy the resources into. Valid choices are: "global, us-east-1, us-east-2, us-west-1, us-west-2." Will be modified to a short id for resource names. | `string`                                                                                                                                                                                                                                                                                 | `"us-west-1"`                                                                            |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                  | The tags to apply to the resources. Set global tag values in the "this" version of the module, and then pass label specific modifications to "module.this.context".      | `map(string)`                                                                                                                                                                                                                                                                            | `{}`                                                                                     |    no    |
| <a name="input_unit"></a> [unit](#input_unit)                                  | The unit identifier that the resources are for. Should be a short-hand identifier.                                                                                       | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                                   |    no    |

## Outputs

| Name                                                                 | Description                                            |
| -------------------------------------------------------------------- | ------------------------------------------------------ |
| <a name="output_delimiter"></a> [delimiter](#output_delimiter)       | The delimiter selected.                                |
| <a name="output_enabled"></a> [enabled](#output_enabled)             | Enable / disable labels or the root module as a whole. |
| <a name="output_environment"></a> [environment](#output_environment) | The environment selected.                              |
| <a name="output_id"></a> [id](#output_id)                            | The id for the resource(s) as configured by the label. |
| <a name="output_labels"></a> [labels](#output_labels)                | value                                                  |
| <a name="output_namespace"></a> [namespace](#output_namespace)       | The appropriate namespace for the resource(s).         |
| <a name="output_region"></a> [region](#output_region)                | The AWS region to deploy resources into.               |
| <a name="output_tags"></a> [tags](#output_tags)                      | The tags compiled by the label.                        |

<!-- END_TF_DOCS -->
