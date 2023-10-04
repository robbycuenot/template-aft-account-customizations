variable "github_installation_id" {
  description = "GitHub installation ID"
  default = ""
}

variable "github_owner" {
  description = "Github Owner"
  default = ""
}

variable "github_token" {
  description = "GitHub Token for creating account repos"
  default = ""
}

variable "organizations_read_only_access_key_id" {
  description = "AWS_ACCESS_KEY_ID for Organization R/O Account"
  default = ""
}

variable "organizations_read_only_secret_access_key" {
  description = "AWS_SECRET_ACCESS_KEY for Organization R/O Account"
  default = ""
}

variable "terraform_aft_token" {
  description = "Terraform AFT Team API Token"
}

variable "terraform_workloads_org_name" {
  description = "Terraform Workloads Organization Name"
}

variable "terraform_workloads_token" {
  description = "Terraform AFT (Workloads) Team API Token"
}

variable "TFC_WORKSPACE_SLUG" {
  description = "DO NOT SET - Managed by TFC - Terraform Cloud workspace slug"
  sensitive    = true
}