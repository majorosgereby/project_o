variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "projecto-cluster"
}

variable "vpc_name" {
  description = "Name of the AWS VPC."
  type        = string
  default     = "project-o-vpc"
}
