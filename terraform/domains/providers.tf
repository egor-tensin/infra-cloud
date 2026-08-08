terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    key = "domains.tfstate"
  }
}

provider "digitalocean" {
}

data "terraform_remote_state" "meta" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "meta.tfstate"
  }
}

data "terraform_remote_state" "vpn_ru" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "vpn-ru.tfstate"
  }
}

data "terraform_remote_state" "vpn" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "vpn.tfstate"
  }
}

data "terraform_remote_state" "web" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "tensin-terraform-state"
    key    = "web.tfstate"
  }
}

locals {
  project_id = data.terraform_remote_state.meta.outputs.project_id
  ip_vpn_ru  = data.terraform_remote_state.vpn_ru.outputs.ip
  ip_vpn     = data.terraform_remote_state.vpn.outputs.ip
  ip_web     = data.terraform_remote_state.web.outputs.ip
}
