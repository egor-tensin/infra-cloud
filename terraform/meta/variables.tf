variable "zone_int" {
  type    = string
  default = "fra1"
}
variable "zone_rus" {
  type    = string
  default = "ru-central1-d"
  # ^^^ The recommended default for "new projects" as of June '26
  # https://yandex.cloud/en/docs/overview/concepts/geo-scope
}

variable "name" {
  type    = string
  default = "Personal"
}
variable "description" {
  type    = string
  default = "My stuff"
}

variable "user" {
  type    = string
  default = "maintenance"
}
variable "ssh_port" {
  type    = number
  default = 993
}
