#
terraform {
  required_version = "= 1.4.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.20.0"
      configuration_aliases = [
        aws,
      ]
    }
  }
}
#
provider "aws" {
  region  = var.region
  profile = local.aws_profile
}
