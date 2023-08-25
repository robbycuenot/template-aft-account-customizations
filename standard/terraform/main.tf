resource "github_repository" "account-id-repository" {
  name        = local.account_name_and_id
  description = "IaC Repository for ${local.account_name_and_id}"

  visibility = "private"
  auto_init = true
}

resource "tfe_workspace" "workspace" {
  name = local.account_name_and_id
  organization = data.tfe_organization.current_organization.name
  project_id = data.tfe_project.workloads.id
  vcs_repo {
    identifier = github_repository.account-id-repository.full_name
    github_app_installation_id = var.github_installation_id
    branch = "main"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Data source used to grab the TLS certificate for Terraform Cloud.
data "tls_certificate" "tfc_certificate" {
  url = "https://app.terraform.io"
}

# Creates an OIDC provider
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}


# Creates a role which can only be used by the specified Terraform cloud workspace.
resource "aws_iam_role" "tfc_role" {
  name = "tfc-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "Federated": "${aws_iam_openid_connect_provider.tfc_provider.arn}"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringEquals": {
         "app.terraform.io:aud": "${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}"
       },
       "StringLike": {
         "app.terraform.io:sub": "organization:${data.tfe_organization.current_organization.name}:project:*:workspace:${tfe_workspace.workspace.name}:run_phase:*"
       }
     }
   }
 ]
}
EOF
}

# Creates a policy that will be used to define the permissions that the previously created role has within AWS.
resource "aws_iam_policy" "tfc_policy" {
  name        = "tfc-policy"
  description = "TFC run policy"

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "*"
     ],
     "Resource": "*"
   }
 ]
}
EOF
}

# Creates an attachment to associate the above policy with the previously created role.
resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = aws_iam_policy.tfc_policy.arn
}

# The following variables must be set to allow runs to authenticate to AWS.
resource "tfe_variable" "enable_aws_provider_auth" {
 workspace_id = tfe_workspace.workspace.id
 
 key      = "TFC_AWS_PROVIDER_AUTH"
 value    = "true"
 category = "env"
 
 description = "Enable the Workload Identity integration for AWS."
}
 
resource "tfe_variable" "tfc_aws_role_arn" {
 workspace_id = tfe_workspace.workspace.id
 
 key      = "TFC_AWS_RUN_ROLE_ARN"
 value    = aws_iam_role.tfc_role.arn
 category = "env"
 
 description = "The AWS role arn runs will use to authenticate."
}
