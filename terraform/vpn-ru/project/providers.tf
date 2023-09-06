terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    key = "vpn-ru/project/terraform.tfstate"
  }
}

provider "yandex" {
  cloud_id  = "b1gj2k9e657bo1fb29nv"
  folder_id = "b1gv5jkqodfl3b96urfl"
}
