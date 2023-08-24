provider "tfe" {
  token = var.terraform_token
}

provider "github" {
  owner = local.github_owner
  token = var.github_token
}

provider "aws" {
  alias = "ro"
  access_key = var.organizations_read_only_access_key_id
  secret_key = var.organizations_read_only_secret_access_key
  region = "us-east-1"
}