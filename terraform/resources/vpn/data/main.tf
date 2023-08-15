module "data" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/data_volume?ref=v1.0.0"

  region     = data.terraform_remote_state.project.outputs.region
  project_id = data.terraform_remote_state.project.outputs.project_id

  name = "${data.terraform_remote_state.project.outputs.project_stub}-data"
}
