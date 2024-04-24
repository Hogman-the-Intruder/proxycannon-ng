data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "azs" {
  all_availability_zones = true
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required", "opted-in"]
  }
}

# If you'd like to use a different AMI, supply it as a terraform variable "ami_id"
# Note that this is an ARM-based image. If you want to use x86, supply an ami_id variable AND change the *_instance_type variables to an EC2 family that supports x86
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}