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

  cname_records = [
    {
      host  = "fm1._domainkey"
      value = "fm1.egort.name.dkim.fmhosted.com."
    },
    {
      host  = "fm2._domainkey"
      value = "fm2.egort.name.dkim.fmhosted.com."
    },
    {
      host  = "fm3._domainkey"
      value = "fm3.egort.name.dkim.fmhosted.com."
    },
  ]
}

resource "digitalocean_record" "fastmail_mx" {
  domain   = module.domain.domain_id
  type     = "MX"
  name     = "@"
  value    = each.key
  priority = each.value

  for_each = {
    for record in local.mx_records :
    record.value => record.priority
  }
}

resource "digitalocean_record" "fastmail_cname" {
  domain = module.domain.domain_id
  type   = "CNAME"
  name   = each.key
  value  = each.value

  for_each = {
    for record in local.cname_records :
    record.host => record.value
  }
}

resource "digitalocean_record" "fastmail_txt" {
  domain = module.domain.domain_id
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:spf.messagingengine.com ?all"
}
