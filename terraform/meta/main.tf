resource "digitalocean_project" "this" {
  name        = var.name
  description = var.description
}

data "digitalocean_ssh_keys" "this" {
  sort {
    key       = "fingerprint"
    direction = "asc"
  }
}

module "vpc_int" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/vpc?ref=master"

  prefix = lower(var.name)
  zone   = var.region
}

module "vpc_rus" {
  source = "github.com/egor-tensin/infra-terraform//yandex/vpc?ref=master"

  prefix = lower(var.name)
  zone   = var.region_ru
}
