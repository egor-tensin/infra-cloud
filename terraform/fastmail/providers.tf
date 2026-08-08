terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    key = "fastmail.tfstate"
  }
}

provider "digitalocean" {
}

data "terraform_remote_state" "domains" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "domains.tfstate"
  }
}
