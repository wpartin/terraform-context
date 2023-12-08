variable "context" {
  description = "A \"context\" object to pass around between modules. The \"this\" module contains the \"root context\" which can be updated by other labels using \"module.this.context\"."
  type        = any
  default     = {
    delimiter = null
    enabled   = true
    env       = null
    namespace = null
    team      = null
  }
}

variable "delimiter" {
  description = "The delimiter to use for separating the ID string components. Either - or _"
  type        = string
  default     = "-"

  validation {
    condition     = contains(["-", "_"], var.delimiter)
    error_message = "delimiter must be either - or _."
  }
}

variable "enabled" {
  description = "Enable / Disable the module."
  type        = bool
  default     = true
}

variable "env" {
  description = "The environment identifier."
  type        = string
  default     = null
}

variable "id" {
  description = "The name for the resource(s)."
  type        = string
  default     = null
}

variable "id_length_limit" {
  description = "The maximum length of an id when combining the appropriate labels."
  type        = number
  default     = 2
}

variable "label_order" {
  description = "The order that the resource labels should be in."
  type        = list(string)
  default     = ["env", "region", "team", "namespace", "id"]
}

variable "namespace" {
  description = "The namespace that the resource belongs to. Example: \"ecs\""
  type        = string
  default     = null
}

variable "region" {
  description = "The AWS region to deploy the resources into. Valid choices are: \"global, us-east-1, us-east-2, us-west-1, us-west-2.\" Will be modified to a short id for resource names."
  type        = string
  default     = null

  validation {
    condition = var.region != null ? contains([
      "global", "us-east-1", "us-east-2",
      "us-west-1", "us-west-2"
    ], var.region) : true

    error_message = <<-EOT
      The only supported regions are global, us-east-1, us-east-2,
      us-west-1, and us-west-2.
    EOT
  }
}

variable "team" {
  description = "The team identifier that the resources are for. Should be a short-hand identifier."
  type        = string
  default     = null
}

variable "tags" {
  description = "The tags to apply to the resources. Set global tag values in the \"this\" version of the module, and then pass label specific modifications to \"module.this.context\"."
  type        = map(string)
  default     = null
}