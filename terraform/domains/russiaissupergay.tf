module "domain_russiaissupergay" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v2.0.0"

  name       = "russiaissuper.gay"
  ip_address = local.ip_web
  project_id = local.project_id
}
