package global.custom_snippet_samples.samples.terraform

# Copyright 2023 Styra Inc. All rights reserved.
# Use of this source code is governed by an Apache2
# license that can be found in the LICENSE file.

import data.global.systemtypes["terraform:2.0"].library.utils.v1 as utils
import data.library.parameters

#############################################################################
# METADATA: library-snippet/terraform
# version: v1
# title: "Allow providers only from specified registries"
# description: >-
#   Allow only providers from specified registries (e.g., registry.terraform.io, private-registry.example.com) to prevent using unapproved registries.
#   Can also be used to allow providers from specific publishers in a registry (e.g., registry.terraform.io/hashicorp).
#   Checks if the provider's full name in the Terraform plan starts with any string from the list specified.
#   To allow all registries, use the '*' wildcard entry.
# custom:
#   id: "custom.allowed_terraform_provider_registries"
#   impact: "Using a provider from an unapproved registry could result in use of unapproved cloud providers or credential exposure to malicious provider plugins"
#   remediation: "Only use Terraform providers from approved registries and publishers"
#   severity: "high"
#   resource_category: "Provider"
#   control_category: "Supply Chain Security"
#   rule_link: "https://docs.styra.com/systems/terraform/snippets"
#   platform:
#     name: "terraform"
#     versions:
#       min: "v0.12"
#       max: "v1.3"
#   rule_targets:
#     - { scope: "provider", argument: "full_name" }
# filePath:
# - systems/.*/policy/.*
# - stacks/.*/policy/.*
# schema:
#   parameters:
#     - name: allowed_registries
#       label: "Allowed provider registries"
#       type: set_of_strings
#       placeholder: "Examples: registry.terraform.io, private-registry.example.com, registry.terraform.io/hashicorp, *"
#       required: true
#   decision:
#     - type: rego
#       key: allowed
#       value: "false"
#     - type: rego
#       key: message
#       value: "violation.message"
#     - type: rego
#       key: metadata
#       value: "violation.metadata"
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[violation]"
#############################################################################
allowed_terraform_provider_registries[violation] {
	provider_registry_allowed[decision]

	violation := {
		"allowed": false,
		"message": decision.message,
		"metadata": utils.build_metadata_return(rego.metadata.rule(), parameters.allowed_registries, decision.resource, decision.context),
	}
}

# Check provider starts with registries specified in rule input
provider_registry_allowed[obj] {
	some provider
	config := input.configuration.provider_config[provider]

	not registry_allowed(config.full_name)

	obj := {
		"message": sprintf("Provider %s registry %s not allowed.", [provider, config.full_name]),
		"resource": config,
		"context": {"full_name": config.full_name},
	}
}

# User allows any registries
registry_allowed(reg) {
	wildcard(parameters.allowed_registries)
}

# User provided list of allowed registries
registry_allowed(reg) {
	not wildcard(parameters.allowed_registries)
	starts_with_any(reg, parameters.allowed_registries)
}

# Helper utils
starts_with_any(str, arr) {
	startswith(str, arr[_])
}

wildcard(arr) {
	arr[_] == "*"
}
