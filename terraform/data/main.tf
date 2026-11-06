module "data_vpn" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/data_volume?ref=v4.0.0"

  name       = "vpn-data"
  zone       = data.terraform_remote_state.meta.outputs.zone_int
  project_id = data.terraform_remote_state.meta.outputs.project_id
}

module "data_vpn_ru" {
  source = "github.com/egor-tensin/infra-terraform//yandex/data_volume?ref=v4.0.0"

  name = "vpn-ru-data"
  zone = data.terraform_remote_state.meta.outputs.zone_rus
}

module "data_web" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/data_volume?ref=v4.0.0"

  name       = "web-data"
  zone       = data.terraform_remote_state.meta.outputs.zone_int
  project_id = data.terraform_remote_state.meta.outputs.project_id
}
