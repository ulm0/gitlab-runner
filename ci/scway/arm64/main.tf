terraform {
  backend "s3" {
    bucket                      = "ulm0"
    key                         = "runner/arm64.tfstate"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}

provider "scaleway" {
  region = "nl-ams"
  zone   = "nl-ams-1"
}

resource "tls_private_key" "runner_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

data "scaleway_image" "docker" {
  architecture = "arm64"
  name         = "Docker"
  most_recent  = true
}

resource "scaleway_account_ssh_key" "runner_key" {
  name       = "runner_key"
  public_key = tls_private_key.runner_key.public_key_openssh
}

data "scaleway_bootscript" "bootscript" {
  architecture = "arm64"
  name_filter  = "4.19 latest"
}

resource "scaleway_server" "runner" {
  name                = "runner"
  image               = data.scaleway_image.docker.id
  dynamic_ip_required = true
  type                = "ARM64-2GB"
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
