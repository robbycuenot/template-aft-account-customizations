terraform {
  required_version = ">= 0.15.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.25.0"
    }
    tfe = {
      version = ">= 0.35.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.28.0"
    }
  }
}