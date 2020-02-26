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
  source = "../module/runner"
  arch = "arm64"
  bootscript_name_filter = "4.19 latest"
  server_type = "ARM64-2GB"
}
