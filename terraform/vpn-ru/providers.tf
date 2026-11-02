terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    key = "vpn-ru.tfstate"
  }
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

data "terraform_remote_state" "data" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "data.tfstate"
  }
}
