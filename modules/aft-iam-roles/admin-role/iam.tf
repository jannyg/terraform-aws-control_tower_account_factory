# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
variable "trusted_entity_type" {
  default = "AWS"
}

variable "role_name" {
  default = "AWSAFTExecution"
}

variable "trusted_entity" {

}

variable "permissions_boundary_arn" {
    type = string
    default = null
}

resource "aws_iam_role" "role" {
  name = var.role_name
  permissions_boundary = var.permissions_boundary_arn

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = templatefile("${path.module}/trust_policy.tpl",
    {
      trusted_entity_type = var.trusted_entity_type
      trusted_entity      = var.trusted_entity
    }
  )

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

output "arn" {
  value = aws_iam_role.role.arn
}
