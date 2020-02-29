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

module "arm64" {
  source                 = "git::https://gitlab.com/ulm0/tf-ci-runner.git"
  arch                   = "arm64"
  bootscript_name_filter = "4.19 latest"
  gitlab_site            = var.gitlab_site
  gitlab_token           = var.gitlab_token
  server_type            = "ARM64-2GB"
}

variable "gitlab_site" {}
variable "gitlab_token" {}
