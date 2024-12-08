variable "region" {
  description = "The aws region"
  type        = string
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
}

variable "project" {
  description = "Name of the project deployment"
  type = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR."
  type        = number
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "Eks_Crealytics_project"
    "Environment" = "Production"
    "Owner"       = "Prasad Naidu"
    "Name"        = "Eks_clusternode1"
  }
}
