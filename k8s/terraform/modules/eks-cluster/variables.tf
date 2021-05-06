data "aws_caller_identity" "current" {
}

variable "environment" {
  type        = string
  description = "Name of environment"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "appname" {
  type        = string
  description = "Application name for naming resources"
}

variable "hosted_zone_name" {
  type        = string
  description = "Name of hosted zone"
}

variable "certificate_domain_name" {
  type        = string
  description = "Domain names to generate certificate in ACM"
}

variable "certificate_alternative_name" {
  type        = list(any)
  default     = []
  description = "Alternative domain names include into certificate"
}

variable "domain_zone_id" {
  description = "Route53 DNS zone ID"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}


variable "eks_cluster_cidr" {
  type        = string
  description = "CIDR Block for EKS cluster VPC"
}

variable "eks_cluster_private_subnets" {
  type        = list(string)
  description = "Private subnets list for EKS cluster"
}

variable "eks_cluster_public_subnets" {
  type        = list(string)
  description = "Public subnets list EKS cluster"
}

variable "eks_cluster_database_subnets" {
  type        = list(string)
  description = "Database subnets list EKS cluster"
}

variable "oidc_enabled" {
  type        = bool
  default     = true
  description = "OIDC enabled to use IAM in EKS"
}

variable "oidc_thumbprint" {
  default     = ""
  description = "OIDC ssl fingerprint"
}

variable "map_users" {
  type        = any
  description = "IAM users to map to k8s users"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

locals {
  service_naming_convention = "${var.appname}-${var.environment}"
}
