resource "yandex_vpc_address" "vpn_ru" {
  name = "vpn-ru-address"

  external_ipv4_address {
    zone_id = data.terraform_remote_state.meta.outputs.region_ru
  }
}

locals {
  ip = yandex_vpc_address.vpn_ru.external_ipv4_address[0].address
}
