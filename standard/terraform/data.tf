data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current_organization" {
  provider = aws.ro
}

data "tfe_organization" "current_organization" {
  name = local.tfc_current_organization_name
}

data "tfe_organization" "workloads" {
  provider = tfe.workloads
  name = var.terraform_workloads_org_name
}

data "tfe_workspace" "current_workspace" {
  name         = local.tfc_current_workspace_name
  organization = data.tfe_organization.current_organization.name
}
