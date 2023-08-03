terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    key = "state/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
}
