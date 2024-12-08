variable "region" {
  type        = string
  description = "region to be hosted on"
}

variable "instance_type" {
  type        = string
  description = "the instance type to use"
}

variable "ami" {
  type        = string
  description = "the ami id to be used"
}

variable "vpc_id" {
  type        = string
  description = "vpc used"
}

