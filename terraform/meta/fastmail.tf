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

  dkim_records = [
    {
      host  = "fm1._domainkey"
      value = "fm1.${local.domain_new}.dkim.fmhosted.com."
    },
    {
      host  = "fm2._domainkey"
      value = "fm2.${local.domain_new}.dkim.fmhosted.com."
    },
    {
      host  = "fm3._domainkey"
      value = "fm3.${local.domain_new}.dkim.fmhosted.com."
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
  name   = each.key
  value  = each.value

  for_each = {
    for record in local.dkim_records :
    record.host => record.value
  }
}

resource "digitalocean_record" "fastmail_spf" {
  domain = module.domain_new.domain_id
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:spf.messagingengine.com ?all"
}
