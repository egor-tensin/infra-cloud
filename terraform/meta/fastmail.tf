locals {
  # The list of domains to configure:
  domains = [
    module.domain_new.domain_id,
    module.domain_cutestdoggroomer.domain_id,
  ]
}

resource "digitalocean_record" "fastmail_mx" {
  domain   = each.value[0]
  type     = "MX"
  name     = "@"
  value    = "in${each.value[1]}-smtp.messagingengine.com."
  priority = each.value[1] * 10

  for_each = {
    for value in setproduct(local.domains, [1, 2]) :
    "${value[0]}-${value[1]}" => value
  }
}

resource "digitalocean_record" "fastmail_dkim" {
  domain = each.value[0]
  type   = "CNAME"
  name   = "fm${each.value[1]}._domainkey"
  value  = "fm${each.value[1]}.${each.value[0]}.dkim.fmhosted.com."

  for_each = {
    for value in setproduct(local.domains, ["1", "2", "3"]) :
    "${value[0]}-${value[1]}" => value
  }
}

resource "digitalocean_record" "fastmail_spf" {
  domain = each.value
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:spf.messagingengine.com ?all"

  for_each = toset(local.domains)
}
