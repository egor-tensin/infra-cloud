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

resource "digitalocean_vpc" "this" {
  name   = "${var.stub}-vpc"
  region = var.region
}

resource "yandex_vpc_network" "this" {
  name = "${var.stub}-vpc"
}

resource "yandex_vpc_subnet" "this" {
  network_id = yandex_vpc_network.this.id

  name           = "${var.stub}-subnet"
  zone           = var.region_ru
  v4_cidr_blocks = ["10.0.0.0/22"]
}
