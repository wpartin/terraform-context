variable "context" {
  default = null
}

variable "delimiter" {
  description = <<-EOT
    The delimiter to use for separating the ID string components.
    Either - or _
  EOT
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
  default     = false
}

variable "env" {
  description = "The environment identifier."
  type        = string
  default     = null
}

variable "id" {
  type    = string
  default = null
}

variable "id_length_limit" {
  type    = string
  default = null
}

variable "namespace" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = null

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
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}