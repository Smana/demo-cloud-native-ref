variable "env" {
  description = "The environment of the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS Region"
  default     = "eu-west-3"
  type        = string
}

# EKS
variable "cluster_name" {
  description = "Name of the EKS cluster to be created"
  type        = string
}

variable "cluster_version" {
  description = "k8s cluster version"
  default     = "1.28"
  type        = string
}

variable "cilium_version" {
  description = "Cilium cluster version"
  default     = "1.14.5"
  type        = string
}

variable "karpenter_version" {
  description = "Karpenter version"
  default     = "v0.32.3"
  type        = string
}

variable "ebs_csi_driver_chart_version" {
  description = "EBS CSI Driver Helm chart version"
  default     = "2.25.0"
  type        = string
}

variable "gateway_api_version" {
  description = "Gateway API CRDs version"
  default     = "v1.0.0"
  type        = string
}

# Flux
variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "github_token" {
  type        = string
  description = "github token"
  sensitive   = true
}

variable "github_repository" {
  type        = string
  description = "github repository name"
}

variable "github_branch" {
  type        = string
  default     = "main"
  description = "Github branch name"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
