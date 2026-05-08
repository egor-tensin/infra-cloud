module "domain_fucktipping" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v1.5.0"

  name       = "fucktipp.ing"
  ip_address = local.ip_web
  project_id = digitalocean_project.this.id
}
