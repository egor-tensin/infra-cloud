variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "project_stub" {
  type    = string
  default = "vpn-ru"
}

variable "ssh_port" {
  type    = number
  default = 993
}
variable "wireguard_port" {
  type    = number
  default = 443
}
