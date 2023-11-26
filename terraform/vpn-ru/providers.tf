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
    key = "vpn-ru.tfstate"
  }
}

provider "digitalocean" {
}

provider "yandex" {
  cloud_id  = "b1gj2k9e657bo1fb29nv"
  folder_id = "b1gv5jkqodfl3b96urfl"
}

data "terraform_remote_state" "meta" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "meta.tfstate"
  }
}
