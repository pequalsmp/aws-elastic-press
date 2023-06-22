variable "container" {
  type = object({
    tag    = string
    digest = string
  })
  description = "The container tag (version) and digest to use for the wordpress image"

  validation {
    condition     = length(var.container.digest) == 71 && substr(var.container.digest, 0, 7) == "sha256:"
    error_message = "The container.digest must be a valid hash, for example 'sha256:0123456789..ef'"
  }
}
