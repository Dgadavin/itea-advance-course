data "aws_caller_identity" "current" {
}

variable "appname" {
  type        = string
  description = "Application name for naming resources"
  default     = "prometheus"
}

variable "environment" {
  type        = string
  description = "Name of environment"
  default     = "dev"
}

variable "hosted_zone" {
  type        = string
  description = "Route53 hosted zone name"
  default     = "itea.devopsology.org"
}
