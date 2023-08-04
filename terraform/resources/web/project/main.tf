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
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v0.0.5"

  name       = "egort.name"
  ip_address = digitalocean_floating_ip.server.ip_address
  project_id = digitalocean_project.this.id

  aliases = ["dev", "git", "id", "shadow", "stash"]
}
