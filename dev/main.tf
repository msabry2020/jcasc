terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}


# Create a base volume for the new VMs (10GB)
resource "libvirt_volume" "vm_disk" {
  name           = "vm-${count.index}"
  pool           = "default"
  size           = 10 * 1024 * 1024 * 1024 # 100GB in bytes
  format         = "qcow2"
  count          = 2
}

resource "libvirt_domain" "vm" {
  count  = 2
  name   = "vm-${count.index}"
  vcpu   = 1
  memory = 2048

  disk {
    volume_id = element(libvirt_volume.vm_disk.*.id, count.index)
  }

  network_interface {
    network_name     = "default"
    addresses      = ["192.168.122.1${count.index}"]
    hostname       = "vm-${count.index}"
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