module "data_vpn" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/data_volume?ref=v1.3.0"

  region     = data.terraform_remote_state.meta.outputs.region
  project_id = data.terraform_remote_state.meta.outputs.project_id

  name = "vpn-data"
}

module "data_web" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/data_volume?ref=v1.3.0"

  region     = data.terraform_remote_state.meta.outputs.region
  project_id = data.terraform_remote_state.meta.outputs.project_id

  name = "web-data"
}
