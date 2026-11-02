module "data_vpn" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/data_volume?ref=v2.1.0"

  name       = "vpn-data"
  region     = data.terraform_remote_state.meta.outputs.region
  project_id = data.terraform_remote_state.meta.outputs.project_id
}

module "data_vpn_ru" {
  source = "github.com/egor-tensin/infra-terraform//yandex/data_volume?ref=v2.1.0"

  name = "vpn-ru-data"
  zone = data.terraform_remote_state.meta.outputs.region_ru
}

module "data_web" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/data_volume?ref=v2.1.0"

  name       = "web-data"
  region     = data.terraform_remote_state.meta.outputs.region
  project_id = data.terraform_remote_state.meta.outputs.project_id
}
