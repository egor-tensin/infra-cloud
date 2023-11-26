variable "region" {
  type    = string
  default = "fra1"
}
variable "region_ru" {
  type    = string
  default = "ru-central1-a"
}

variable "name" {
  type    = string
  default = "Infra"
}
variable "description" {
  type    = string
  default = "My stuff"
}
variable "stub" {
  type    = string
  default = "infra"
}

variable "user" {
  type    = string
  default = "maintenance"
}
variable "ssh_port" {
  type    = number
  default = 993
}
