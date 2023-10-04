variable "github_token" {
  description = "GitHub Token for creating account repos"
}

variable "github_owner" {
  description = "Github Owner"
}

variable "terraform_aft_token" {
  description = "Terraform AFT Team Token"
}

variable "terraform_workloads_token" {
  description = "Terraform AFT (Workloads) Team Token"
}

variable "github_installation_id" {
  description = "Github app installation ID"
}

variable "organizations_read_only_access_key_id" {
  description = "Organizations R/O Access Key ID"
}

variable "organizations_read_only_secret_access_key" {
  description = "Organizations R/O Secret Access Key"
}

variable "TFC_WORKSPACE_SLUG" {
  description = "DO NOT SET - Managed by TFC - Terraform Cloud workspace slug"
}
