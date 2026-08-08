module "domain_fucktipping" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v2.0.0"

  name       = "fucktipp.ing"
  ip_address = local.ip_web
  project_id = local.project_id
}
