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

# resource "aws_iam_openid_connect_provider" "tfc_provider" {
#   url             = data.tls_certificate.tfc_certificate.url
#   client_id_list  = [local.tfc_aws_audience]
#   thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
# }

# resource "aws_iam_role" "tfc_role" {
#   name = "tfc-role"

#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Principal": {
#        "Federated": "${aws_iam_openid_connect_provider.tfc_provider.arn}"
#      },
#      "Action": "sts:AssumeRoleWithWebIdentity",
#      "Condition": {
#        "StringEquals": {
#          "${var.tfc_hostname}:aud": "${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}"
#        },
#        "StringLike": {
#          "${var.tfc_hostname}:sub": "organization:${var.tfe_organization}:project:${var.tfe_default_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
#        }
#      }
#    }
#  ]
# }
# EOF
# }
