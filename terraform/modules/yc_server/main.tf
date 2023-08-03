locals {
  sshd_config = templatefile("${path.module}/etc/sshd_config", {
    port  = var.ssh_port
    users = [var.user]
  })
}

resource "yandex_compute_instance" "this" {
  zone     = var.zone
  name     = var.name
  hostname = var.name

  resources {
    cores         = var.cores
    core_fraction = var.core_fraction
    memory        = var.memory
  }

  boot_disk {
    initialize_params {
      size     = var.disk_size
      image_id = var.image
    }
  }

  network_interface {
    subnet_id      = var.subnet_id
    nat            = true
    nat_ip_address = var.ip_address
  }

  metadata = {
    user-data = templatefile("${path.module}/etc/cloud-init.cfg", {
      user        = var.user
      ssh_keys    = var.ssh_keys
      sshd_config = local.sshd_config
    })
  }

  allow_stopping_for_update = true
}
