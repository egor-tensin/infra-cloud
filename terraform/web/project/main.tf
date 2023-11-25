resource "digitalocean_project" "this" {
  name        = var.name
  description = var.description
}

resource "digitalocean_vpc" "this" {
  name   = "${var.stub}-vpc"
  region = var.region
}

resource "digitalocean_floating_ip" "server" {
  region = var.region
}

resource "digitalocean_project_resources" "this" {
  project   = digitalocean_project.this.id
  resources = [digitalocean_floating_ip.server.urn]
}

locals {
  domain_old = "egort.name"
  domain_new = "tensin.name"
  subdomains = ["dev", "git", "id", "shadow", "stash"]
}

module "domain_old" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v1.0.0"

  name       = local.domain_old
  ip_address = digitalocean_floating_ip.server.ip_address
  project_id = digitalocean_project.this.id

  aliases = local.subdomains
}

module "domain_new" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v1.0.0"

  name       = local.domain_new
  ip_address = digitalocean_floating_ip.server.ip_address
  project_id = digitalocean_project.this.id

  aliases = local.subdomains
}

resource "digitalocean_record" "vpn_old" {
  domain = module.domain_old.domain_id
  type   = "CNAME"
  name   = "vpn"
  value  = "vpn.${local.domain_new}."
}

resource "digitalocean_record" "vpn_new" {
  domain = module.domain_new.domain_id
  type   = "A"
  name   = "vpn"
  value  = data.terraform_remote_state.vpn.outputs.server_ip
}

resource "digitalocean_record" "vpn_ru_old" {
  domain = module.domain_old.domain_id
  type   = "CNAME"
  name   = "vpn-ru"
  value  = "vpn-ru.${local.domain_new}."
}

resource "digitalocean_record" "vpn_ru_new" {
  domain = module.domain_new.domain_id
  type   = "A"
  name   = "vpn-ru"
  value  = data.terraform_remote_state.vpn_ru.outputs.server_ip
}
