variable "environment_name" {
  description = "The environment name for the infrastructure project"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "The Azure region to deploy the infrastructure to"
  type        = string
  default     = "germanywestcentral"
}
