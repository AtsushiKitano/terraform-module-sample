remote_state {
  backend = "gcs"

  config = {
    bucket = "${get_env("TF_VAR_project")}-state"
    prefix = "terratest/${path_relative_to_include()}"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-east-2"
}
EOF
}

generate "backend" {
  path = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "gcs" {}
}
EOF
}

