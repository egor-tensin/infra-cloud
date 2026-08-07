resource "digitalocean_floating_ip" "vpn" {
  region = var.region
}

resource "digitalocean_floating_ip" "web" {
  region = var.region
}

#
# I'm tired, boss:
#     https://github.com/digitalocean/terraform-provider-digitalocean/issues/1455
#
#resource "digitalocean_project_resources" "project_ip" {
#  project   = digitalocean_project.this.id
#  resources = [each.value]
#
#  for_each = toset([
#    digitalocean_floating_ip.vpn.urn,
#    digitalocean_floating_ip.web.urn,
#  ])
#}

resource "yandex_vpc_address" "vpn_ru" {
  name = "vpn-ru-address"

  external_ipv4_address {
    zone_id = var.region_ru
  }
}

locals {
  ip_web    = digitalocean_floating_ip.web.ip_address
  ip_vpn    = digitalocean_floating_ip.vpn.ip_address
  ip_vpn_ru = yandex_vpc_address.vpn_ru.external_ipv4_address[0].address
}
