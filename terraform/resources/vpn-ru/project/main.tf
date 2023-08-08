resource "yandex_vpc_network" "this" {
  name = "${var.project_stub}-vpc"
}

resource "yandex_vpc_subnet" "this" {
  network_id = yandex_vpc_network.this.id

  name           = "${var.project_stub}-subnet"
  zone           = var.zone
  v4_cidr_blocks = ["10.0.0.0/22"]
}

resource "yandex_vpc_address" "server" {
  name = "${var.project_stub}-address"

  external_ipv4_address {
    zone_id = var.zone
  }
}
