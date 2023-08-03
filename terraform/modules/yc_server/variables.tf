variable "zone" {
  type = string
}

variable "name" {
  type = string
}
variable "image" {
  type = string
  # Debian 11
  default = "fd8sqojvm458b3jr5nfd"
}
variable "subnet_id" {
  type = string
}
variable "ip_address" {
  type = string
}

variable "user" {
  type = string
}
variable "ssh_keys" {
  type = list(string)
}
variable "ssh_port" {
  type    = string
  default = "22"
}

variable "cores" {
  type    = number
  default = 2
}
variable "core_fraction" {
  type    = number
  default = 100
}
variable "memory" {
  type    = number
  default = 2
}
variable "disk_size" {
  type    = number
  default = 10
}
