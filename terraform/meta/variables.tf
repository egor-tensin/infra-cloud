variable "region" {
  type    = string
  default = "fra1"
}
variable "region_ru" {
  type    = string
  default = "ru-central1-d"
  # ^^^ The recommended default for "new projects" as of June '26
}

variable "name" {
  type    = string
  default = "Personal"
}
variable "description" {
  type    = string
  default = "My stuff"
}
variable "stub" {
  type    = string
  default = "personal"
}

variable "user" {
  type    = string
  default = "maintenance"
}
variable "ssh_port" {
  type    = number
  default = 993
}
