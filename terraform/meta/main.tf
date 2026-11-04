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

moved {
  from = digitalocean_vpc.this
  to = module.vpc_int.digitalocean_vpc.this
}

module "vpc_rus" {
  source = "github.com/egor-tensin/infra-terraform//yandex/vpc?ref=master"

  prefix = lower(var.name)
  zone   = var.region_ru
}

moved {
  from = yandex_vpc_network.this
  to = module.vpc_rus.yandex_vpc_network.this
}

moved {
  from = yandex_vpc_subnet.this
  to = module.vpc_rus.yandex_vpc_subnet.this
}
