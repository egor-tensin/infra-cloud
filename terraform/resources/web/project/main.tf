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

module "domain" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=cbffba1"

  name       = "egort.name"
  ip_address = digitalocean_floating_ip.server.ip_address
  project_id = digitalocean_project.this.id

  aliases = ["dev", "git", "id", "shadow", "stash"]
}

resource "digitalocean_record" "a_vpn" {
  domain = module.domain.domain_id
  type   = "A"
  name   = "vpn"
  value  = data.terraform_remote_state.vpn.outputs.server_ip
}

resource "digitalocean_record" "a_vpn_ru" {
  domain = module.domain.domain_id
  type   = "A"
  name   = "vpn-ru"
  value  = data.terraform_remote_state.vpn_ru.outputs.server_ip
}
