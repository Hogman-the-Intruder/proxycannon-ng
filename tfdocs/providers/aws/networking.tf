locals {
  subnets = [for i in range(0, var.subnet_count) : cidrsubnet(var.vpc_cidr, 8, i)]
}

module "proxycannon-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "proxycannon-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.azs.names
  public_subnets  = slice(local.subnets, 0, length(data.aws_availability_zones.azs.names))

  enable_nat_gateway = false
}

resource "aws_security_group" "proxycannon-command-group" {
  name = "proxycannon-command-sg"
  description = "Security group for the proxycannon COMMAND node"
  vpc_id = module.proxycannon-vpc.vpc_id

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "proxycannon-exit-group" {
  name = "proxycannon-exit-sg"
  description = "Security group for the proxycannon exit nodes"
  vpc_id = module.proxycannon-vpc.vpc_id

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}