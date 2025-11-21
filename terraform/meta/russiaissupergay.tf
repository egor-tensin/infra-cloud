module "domain_russiaissupergay" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v1.2.0-fixme"

  name       = "russiaissuper.gay"
  ip_address = local.ip_web
  project_id = digitalocean_project.this.id
}
