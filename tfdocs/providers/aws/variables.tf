# This file contains the variables the user needs to provide

## Default Server Count for Exit Nodes
variable "server_count" {
    default = 2
}

# key-file should be the full location of the private key used for the VPS of choice
variable "key-file" {}

variable "public_key" {
  description = "The PUBLIC key to use for SSH auth to the instances."
}

# name should be set to the name of the public key onfile with your provider
variable "sshName" {}

variable "isAWS" {
    type = bool
    default = false
}

variable "ami_id" {
  description = "The ID of the AMI to use in AWS. Leave blank to use the latest arm64 Ubuntu 22.04 image."
  type = string
  default = null
}

variable "exit_instance_type" {
  description = "The EC2 instance type to use for exit nodes. Defaults to t4g.nano. Note that this is an ARM-based instance type, change to t3a or some other family for x86."
  type = string
  default = "t4g.nano"
}

variable "control_instance_type" {
  description = "The EC2 instance type to use for the control node. Defaults to t4g.small. Note that this is an ARM-based instance type, change to t3a or some other family for x86."
  type = string
  default = "t4g.small"
}

variable "vpc_cidr" {
  description = "The private IPv4 network block to use for the VPC. Defaults to 10.123.0.0/16. Must be valid private IPv4 range with appropriate subnet mask."
  type = string
  default = "10.123.0.0/16"
}

# By default, subnets are created across AZs in the current region in a round-robin fashion.
# Setting this number higher than the number of AZs will create duplicate subnets across several/all AZs
variable "subnet_count" {
  description = "The number of public subnets to create within the VPC."
  type = number
  default = 3
}