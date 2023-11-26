resource "digitalocean_floating_ip" "vpn" {
  region = var.region
}

resource "digitalocean_project_resources" "vpn_ip" {
  project   = digitalocean_project.this.id
  resources = [digitalocean_floating_ip.vpn.urn]
}

resource "digitalocean_floating_ip" "web" {
  region = var.region
}

resource "digitalocean_project_resources" "web_ip" {
  project   = digitalocean_project.this.id
  resources = [digitalocean_floating_ip.web.urn]
}

resource "yandex_vpc_address" "vpn_ru" {
  name = "vpn-ru-address"

  external_ipv4_address {
    zone_id = var.region_ru
  }
}

locals {
  vpn_ru_ip = yandex_vpc_address.vpn_ru.external_ipv4_address[0].address
}
