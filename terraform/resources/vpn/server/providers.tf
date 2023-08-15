terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    key = "vpn/server/terraform.tfstate"
  }
}

provider "digitalocean" {
}

data "terraform_remote_state" "project" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "vpn/project/terraform.tfstate"
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "vpn/data/terraform.tfstate"
  }
}
