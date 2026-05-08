module "server" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/server?ref=v1.4.0-test"

  # See infra-terraform for details.
  #image = ""
  #size  = ""

  region     = data.terraform_remote_state.meta.outputs.region
  project_id = data.terraform_remote_state.meta.outputs.project_id

  name       = "web-server"
  vpc_id     = data.terraform_remote_state.meta.outputs.vpc_id
  ip_address = data.terraform_remote_state.meta.outputs.server_ip_web
  volume_ids = [data.terraform_remote_state.data.outputs.volume_id_web]

  user     = data.terraform_remote_state.meta.outputs.user
  ssh_keys = data.terraform_remote_state.meta.outputs.ssh_keys
  ssh_port = data.terraform_remote_state.meta.outputs.ssh_port

  size = "s-2vcpu-4gb"
}
