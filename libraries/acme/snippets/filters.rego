package libraries.acme.snippets

import data.library.parameters

import data.global.systemtypes["entitlements:1.0"].library.utils.v1 as utils

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1.0 
# title: "-12-- ACME: Filter Action" 
# description: >-
#   Matches requests where the input.action is a member of the list
# details: >-
#   This snippet replaces the prior filter support in swimlanes
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   parameters:
#     - name: "actions"
#       label: Actions
#       type: set_of_strings
#       placeholder: "Actions"
#   decision:
#     - type: toggle
#       label: Permission
#       toggles:
#       - key: allowed
#         value: true
#         label: Allow
#       - key: denied
#         value: true
#         label: Deny
#     - type: rego
#       key: entz
#       value: "set()"
#     - type: rego
#       key: message
#       value: "obj.message" 
#############################################################################
filterAction[obj] { 
	print("params ", parameters)
	obj := {"message": "a Message"}
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1.0
# title: "-12-- ACME: Filter Resource"
# description: >-
#   Matches requests where the input.resource is a member of the list
# details: >-
#   This snippet replaces the prior filter support in swimlanes
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   parameters:
#     - name: "resources"
#       label: Resources
#       type: set_of_strings
#       placeholder: "Resources"
#   decision:
#     - type: toggle
#       label: Permission
#       toggles:
#       - key: allowed
#         value: true
#         label: Allow
#       - key: denied
#         value: true
#         label: Deny
#     - type: rego
#       key: entz
#       value: "set()"
#     - type: rego
#       key: message
#       value: "obj.message" 
#############################################################################
filterResource[obj] { 
	print("params ", parameters)
	obj := {"message": "a Message"}
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1.0
# title: "-12-- ACME: Filter Subject"
# description: >-
#   Matches requests where the input.subject is a member of the list
# details: >-
#   This snippet replaces the prior filter support in swimlanes
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   parameters:
#     - name: "subjects"
#       label: Subjects
#       type: set_of_strings
#       placeholder: "Subjects"
#   decision:
#     - type: toggle
#       label: Permission
#       toggles:
#       - key: allowed
#         value: true
#         label: Allow
#       - key: denied
#         value: true
#         label: Deny
#     - type: rego
#       key: entz
#       value: "set()"
#     - type: rego
#       key: message
#       value: "obj.message" 
#############################################################################
filterSubject[obj] { 
	print("params ", parameters)
	obj := {"message": "a Message"}
}
