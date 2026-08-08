locals {
  domain_old = "egort.name"
  domain_new = "tensin.name"
  subdomains = [
    "dev",
    "git",
    "id",
    "paste",
    "shadow",
    "test",
  ]
}

module "domain_new" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v2.0.0"

  name       = local.domain_new
  ip_address = local.ip_web
  project_id = local.project_id

  aliases = local.subdomains
}

resource "digitalocean_record" "vpn_new" {
  domain = module.domain_new.domain_id
  type   = "A"
  name   = "vpn"
  value  = local.ip_vpn
}

resource "digitalocean_record" "vpn_ru_new" {
  domain = module.domain_new.domain_id
  type   = "A"
  name   = "vpn-ru"
  value  = local.ip_vpn_ru
}

# The old domain points to the same IP address as the new domain (nginx will do
# the redirection); additionally, it has a wildcard CNAME to point to the same
# thing. If a subdomain doesn't exist under the new domain, the client will
# fail at DNS resolution.

module "domain_old" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/domain?ref=v2.0.0"

  name       = local.domain_old
  ip_address = local.ip_web
  project_id = local.project_id

  aliases = ["*"]
}

# These aliases have to be maintained because I have a bunch of devices set up
# to use vpn{-ru}.egort.name for Wireguard.

resource "digitalocean_record" "vpn_old" {
  domain = module.domain_old.domain_id
  type   = "CNAME"
  name   = "vpn"
  value  = "vpn.${local.domain_new}."
}

resource "digitalocean_record" "vpn_ru_old" {
  domain = module.domain_old.domain_id
  type   = "CNAME"
  name   = "vpn-ru"
  value  = "vpn-ru.${local.domain_new}."
}
