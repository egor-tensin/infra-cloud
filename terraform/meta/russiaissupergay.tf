module "domain_russiaissupergay" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v1.4.0"

  name       = "russiaissuper.gay"
  ip_address = local.ip_web
  project_id = digitalocean_project.this.id
}
