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
    key = "meta.tfstate"
  }
}

provider "digitalocean" {
}

provider "yandex" {
}
