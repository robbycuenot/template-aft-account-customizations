locals {
  account_id = data.aws_caller_identity.current.account_id
  account_name = element([for account in data.aws_organizations_organization.org.accounts[*]: account if "${account.id}" == local.account_id], 0).name
  account_name_and_id = format("%s-%s", local.account_name, local.account_id)

  tfc_workspace_slug_split = split("/", var.TFC_WORKSPACE_SLUG)
  tfc_current_organization_name    = local.tfc_workspace_slug_split[0]
  tfc_current_workspace_name       = local.tfc_workspace_slug_split[1]

  github_identifier = data.tfe_workspace.current_workspace.vcs_repo["0"].identifier
  github_identifier_split = split("/", local.github_identifier)
  github_owner = local.github_identifier_split[0]
}
