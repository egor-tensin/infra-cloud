locals {
  mx_records = [
    {
      priority = 10
      value    = "in1-smtp.messagingengine.com."
    },
    {
      priority = 20
      value    = "in2-smtp.messagingengine.com."
    },
  ]
}

resource "digitalocean_record" "fastmail_mx" {
  domain   = module.domain_new.domain_id
  type     = "MX"
  name     = "@"
  value    = each.key
  priority = each.value

  for_each = {
    for record in local.mx_records :
    record.value => record.priority
  }
}

resource "digitalocean_record" "fastmail_dkim" {
  domain = module.domain_new.domain_id
  type   = "CNAME"
  name   = "fm${each.value}._domainkey"
  value  = "fm${each.value}.${local.domain_new}.dkim.fmhosted.com."

  for_each = toset(["1", "2", "3"])
}

resource "digitalocean_record" "fastmail_spf" {
  domain = module.domain_new.domain_id
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:spf.messagingengine.com ?all"
}
