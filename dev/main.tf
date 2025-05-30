terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

variable "tf_vm_name" {
  type = string
}

provider "libvirt" {
  uri = "qemu+ssh://eng_muhammedsabry:admin@34.172.121.81:22/system?sshauth=ssh-password"
}


# Create a base volume for the new VMs (10GB)
resource "libvirt_volume" "vm_disk" {
  name           = "${var.tf_vm_name}"
  pool           = "default"
  size           = 10 * 1024 * 1024 * 1024 # 100GB in bytes
  format         = "qcow2"
}

resource "libvirt_domain" "vm" {
  name   = "${var.tf_vm_name}"
  vcpu   = 1
  memory = 2048

  disk {
    volume_id = element(libvirt_volume.vm_disk.*.id, 0)
  }

  network_interface {
    network_name     = "default"
    addresses      = ["192.168.122.10"]
    hostname       = "${var.tf_vm_name}"
  }

  boot_device {
    dev = ["hd", "cdrom"]
  }

# Enable VNC console
  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }

  # Set CPU mode to host-passthrough
  cpu {
    mode = "host-passthrough"
  }

}