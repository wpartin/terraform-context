## Introduction
This module aims to assist in making resource naming and tagging across root modules more consistent and easier to manage.
To instantiate this module for use, first create a `this` version of the module that will create your base `context` object.
The `context` object gets passed around and can be modified in any subsequent `label` modules as needed.

## Usage

```hcl
### context.tf ###
module "this" {
  source = "../.."

  env       = "sandbox"
  namespace = "ecs"

  tags = {
    Account     = "Development"
    Cost-Center = "Engineering"
    Domain      = "Containers"
    Environment = "Sandbox"
    Project     = "Goldenrod"
  }
}

module "ecs_cluster_label" {
  source = "../.."

  id     = "cluster"
  region = "global"

  context = module.this.context
}

module "ecs_service_label" {
  source = "../.."

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
  count = module.ecs_cluster_label.enabled ? 1 : 0

  name = module.ecs_cluster_label.id_full

  tags = module.ecs_cluster_label.tags
}

module "service" {
  source = "./modules/ecs-service"

  enabled            = module.ecs_service_label.enabled
  enable_autoscaling = true
  family             = module.ecs_service_label.id
  name               = module.ecs_service_label.id_full
  namespace          = module.ecs_service_label.namespace

  tags    = module.ecs_service_label.tags
}

resource "aws_sqs_queue" "this" {
  count = module.ecs_service_label.enabled ? 1 : 0

  name = replace(module.ecs_service_label.id_full, "ecs", "sqs")

  tags = merge(module.ecs_service_label.tags, {
    Domain = "SQS"
  })
}

### example of context outputs ###
ecs_cluster_label = {
    context = {
        delimiter = "-"
        enabled   = true
        env       = "sandbox"
        id        = "cluster"
        namespace = "ecs"
        region    = "glb"
        tags      = {
            Account     = "Development"
            Cost-Center = "Engineering"
            Domain      = "Containers"
            Environment = "Sandbox"
            Project     = "Goldenrod"
        }
        team      = null
    }
    enabled = true
    id      = "cluster"
    id_full = "sandbox-glb-ecs-cluster"
    region  = "global"
    tags    = {
        Account     = "Development"
        Cost-Center = "Engineering"
        Domain      = "Containers"
        Environment = "Sandbox"
        Project     = "Goldenrod"
    }
}
ecs_service_label = {
    context = {
        delimiter = "-"
        enabled   = true
        env       = "sandbox"
        id        = "foxtrot"
        namespace = "ecs"
        region    = "use2"
        tags      = {
            Account     = "Development"
            Cost-Center = "BugsLife"
            Domain      = "Containers"
            Environment = "Sandbox"
            Project     = "Goldenrod"
        }
        team      = null
    }
    enabled = true
    id      = "foxtrot"
    id_full = "sandbox-use2-ecs-foxtrot"
    region  = "us-east-2"
    tags    = {
        Account     = "QA"
        Cost-Center = "BugsLife"
        Domain      = "Containers"
        Environment = "Sandbox"
        Project     = "Goldenrod"
    }
}
this = {
    context = {
        delimiter = "-"
        enabled   = true
        env       = "sandbox"
        id        = null
        namespace = "ecs"
        region    = null
        tags      = {
            Account     = "Development"
            Cost-Center = "Engineering"
            Domain      = "Containers"
            Environment = "Sandbox"
            Project     = "Goldenrod"
        }
        team      = null
    }
    enabled = true
    id      = null
    id_full = "sandbox-ecs"
    region  = null
    tags    = {
        Account     = "Development"
        Cost-Center = "Engineering"
        Domain      = "Containers"
        Environment = "Sandbox"
        Project     = "Goldenrod"
    }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | A "context" object to pass around between modules. The "this" module contains the "root context" which can be updated by other labels using "module.this.context". | `any` | <pre>{<br>  "delimiter": null,<br>  "enabled": true,<br>  "env": null,<br>  "namespace": null,<br>  "team": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | The delimiter to use for separating the ID string components. Either - or \_ | `string` | `"-"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable / Disable the module. | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment identifier. | `string` | `null` | no |
| <a name="input_id"></a> [id](#input\_id) | The name for the resource(s). | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | The maximum length of an id when combining the appropriate labels. | `number` | `2` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order that the resource labels should be in. | `list(string)` | <pre>[<br>  "env",<br>  "region",<br>  "team",<br>  "namespace",<br>  "id"<br>]</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace that the resource belongs to. Example: "ecs" | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources into. Valid choices are: "global, us-east-1, us-east-2, us-west-1, us-west-2." Will be modified to a short id for resource names. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the resources. Set global tag values in the "this" version of the module, and then pass label specific modifications to "module.this.context". | `map(string)` | `null` | no |
| <a name="input_team"></a> [team](#input\_team) | The team identifier that the resources are for. Should be a short-hand identifier. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_context"></a> [context](#output\_context) | The output context that can be passed around with other labels. The root context can be accessed with: "module.this.context". |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Enable / disable labels or the root module as a whole. |
| <a name="output_id"></a> [id](#output\_id) | The id for the resource(s) as configured by the label. |
| <a name="output_id_full"></a> [id\_full](#output\_id\_full) | The full id for the resource(s) as configured by the label; includes any labels included in "var.label\_order". |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The appropriate namespace for the resource(s). |
| <a name="output_region"></a> [region](#output\_region) | The AWS region to deploy resources into. |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags compiled by the label. |
<!-- END_TF_DOCS -->