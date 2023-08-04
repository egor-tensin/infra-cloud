resource "yandex_vpc_network" "this" {
  name = "${var.project_stub}-vpc"
}

resource "yandex_vpc_subnet" "this" {
  network_id = yandex_vpc_network.this.id

  name           = "${var.project_stub}-subnet"
  zone           = var.zone
  v4_cidr_blocks = ["10.0.0.0/22"]
}

module "firewall" {
  source = "github.com/egor-tensin/infra-terraform//yandex/firewall?ref=v0.0.2"

  name       = "${var.project_stub}-firewall"
  vpc_id     = yandex_vpc_network.this.id
  open_ports = [var.ssh_port, var.wireguard_port]
}

resource "yandex_vpc_address" "this" {
  name = "${var.project_stub}-address"

  external_ipv4_address {
    zone_id = var.zone
  }
}
