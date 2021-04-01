terraform {
  backend "s3" {
    bucket  = "ulm0-tf-backend"
    key     = "runner/gitlab-ci-arm"
    encrypt = true
    region  = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "arm" {
  source          = "git::https://gitlab.com/innersea/tf-modules/gitlab-runner.git"
  name            = "ARM runner builder"
  gitlab_token    = var.gitlab_token
  run_as_platform = "arm"
}

variable "gitlab_token" {}
