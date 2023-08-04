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
