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
  default     = "1.30"
  type        = string
}

variable "enable_ssm" {
  description = "If true, allow to connect to the instances using AWS Systems Manager"
  type        = bool
  default     = false
}

variable "iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = map(string)
  default     = {}
}

variable "cilium_version" {
  description = "Cilium cluster version"
  default     = "1.16.0"
  type        = string
}

variable "karpenter_version" {
  description = "Karpenter version"
  default     = "0.37.0"
  type        = string
}

variable "karpenter_limits" {
  description = "Define limits for Karpenter per node pool."
  type = map(object(
    {
      cpu    = optional(number, 50),
      memory = optional(string, "50Gi")
    }
    )
  )
}

variable "ebs_csi_driver_chart_version" {
  description = "EBS CSI Driver Helm chart version"
  default     = "2.25.0"
  type        = string
}

variable "gateway_api_version" {
  description = "Gateway API CRDs version"
  default     = "v1.1.0"
  type        = string
}

# Flux
variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "github_token_secretsmanager_name" {
  type        = string
  description = "SecretsManager name from where to retrieve the Github token. (The key must be 'github-token')"
  default     = "github/flux-github-token"
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
