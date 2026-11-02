terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    key = "data.tfstate"
  }
}

provider "digitalocean" {
}

provider "yandex" {
}

data "terraform_remote_state" "meta" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "meta.tfstate"
  }
}
