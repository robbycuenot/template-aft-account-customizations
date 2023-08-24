data "aws_caller_identity" "current" {}

data "tfe_organization" "current_organization" {
  name = local.tfc_current_organization_name
}

data "tfe_workspace" "current_workspace" {
  name         = local.tfc_current_workspace_name
  organization = data.tfe_organization.current_organization.name
}

data "tfe_project" "workloads" {
  name         = "Workloads"
  organization = data.tfe_organization.current_organization.name
}