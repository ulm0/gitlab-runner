terraform {
  backend "s3" {
    bucket  = "ulm0-tf-backend"
    key     = "runner/gitlab-ci-arm64"
    encrypt = true
    region  = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "arm64" {
  source       = "git::https://gitlab.com/innersea/tf-modules/gitlab-runner.git"
  gitlab_token = var.gitlab_token
}

variable "gitlab_token" {}
