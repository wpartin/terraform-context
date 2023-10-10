variable "attributes" {
  description = "Additional attributes to include in the ID string for resources."
  type = list(string)
  default = null
}

variable "context" {
  default = {
    attributes = []
    enabled    = false
    id         = null
    tags       = {}
  }
}

variable "delimiter" {
  description = <<-EOT
    The delimiter to use for separating the ID string components.
    Either - or _
  EOT
  type = string
  default = "-"

  validation {
    condition = contains(["-", "_"], var.delimiter)
    error_message = "delimiter must be either - or _."
  }
}

variable "enabled" {
  description = "Enable / Disable the context module."
  type = bool
}

variable "env" {
  description = "The environment identifier."
  type = string
}

variable "id" {
  type = string
  default = null
}

variable "namespace" {
  type = string
}

variable "region" {
  type = string

  validation {
    condition = contains([
      "us-east-1", "us-east-2",
      "us-west-1", "us-west-2"
    ], var.region)

    error_message = <<-EOT
      The only supported regions are us-east-1, us-east-2,
      us-west-1, and us-west-2.
    EOT
  }
}

variable "team" {
  type = string
}

variable "tags" {
  type = map(string)
}