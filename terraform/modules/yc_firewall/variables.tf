variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "open_ports" {
  type = list(number)
}
