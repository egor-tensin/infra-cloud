terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    key = "web/project/terraform.tfstate"
  }
}

provider "digitalocean" {
}
