module "domain_cutestdoggroomer" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v1.1.1"

  name       = "cutestdoggroomer.com"
  ip_address = local.ip_web
  project_id = digitalocean_project.this.id
}
