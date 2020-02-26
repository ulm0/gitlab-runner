resource "tls_private_key" "runner_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

data "scaleway_image" "docker" {
  architecture = var.arch
  name         = "Docker"
  most_recent  = true
}

resource "scaleway_account_ssh_key" "runner_key" {
  name       = format("ssh-key-%s", var.arch)
  public_key = tls_private_key.runner_key.public_key_openssh
}

data "scaleway_bootscript" "bootscript" {
  architecture = var.arch
  name_filter  = var.bootscript_name_filter
}

resource "scaleway_server" "runner" {
  name                = format("runner-%s", var.arch)
  image               = data.scaleway_image.docker.id
  dynamic_ip_required = true
  type                = var.server_type
  boot_type           = "bootscript"
  bootscript          = data.scaleway_bootscript.bootscript.id

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.public_ip
    private_key = tls_private_key.runner_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "docker info",
      "uname -a",
    ]
  }
}
