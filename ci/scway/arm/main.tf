terraform {
  backend "s3" {
    bucket                      = "ulm0"
    key                         = "runner/arm.tfstate"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}

provider "scaleway" {
  region = "fr-par"
  zone   = "fr-par-1"
}

module "arm" {
  source = "../module/runner"
  arch = "arm"
  bootscript_name_filter = "4.9 latest"
  server_type = "C1"
}
