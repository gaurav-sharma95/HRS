variable "region" {
  description = "Name of the AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "cluster-version" {
  description = "Version for the EKS Cluster"
  type        = string
  default     = "1.28"
}

variable "cluster-name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "EKS-Cluster"
}

variable "access_key" {
  type        = string
  description = "Access Key ID For AWS"
}

variable "secret_key" {
  type        = string
  description = "Secret Key For AWS"
}

