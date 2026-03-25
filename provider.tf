provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_version = "~>1.14.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.28"
    }
  }
}