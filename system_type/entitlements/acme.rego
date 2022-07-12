package global.acme_snippets.system_type.entitlements

import data.library.parameters

inthefile := ["a"]

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet-1"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
#############################################################################
custom_snippet_1[msg] {
	msg := "ACME: Custom Snippet-1"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet-2"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet asks the user to enter one parameter, the subjects (aka users).  
#   It does not provide any guidance for those values.
# schema:
#   type: object
#   properties:
#     subjects:
#       type: array
#       title: "Match subjects"
#       items:
#         type: string
#       uniqueItems: true
#############################################################################
custom_snippet_2[msg] {
	msg := sprintf("ACME: Custom Snippet-2 parameters subjects(%s)", [data.library.parameters.subjects])
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet-3"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet asks the users for 3 different parameters, subjects, actions, resources.
#   For each one of these parameters, it provides hints as to what the values are that the user should select from
# schema:
#   type: object
#   properties:
#     subjects:
#       type: array
#       title: "Match subjects"
#       items:
#         type: string
#       uniqueItems: true
#       "hint:items":
#         package: "completions"
#         query: "subjects"
#     actions:
#       type: array
#       title: "Match Actions"
#       items:
#         type: string
#       uniqueItems: true
#       "hint:items":
#         package: "object"
#         query: "actions"
#     resources:
#       type: array
#       title: "Resource selector and dropdown"
#       items:
#         type: string
#       uniqueItems: true
#       "hint:items":
#         package: "transform.snippet"
#         query: "resources"
#############################################################################
custom_snippet_3[msg] {
	msg := sprintf("ACME: Custom Snippet-3 parameters subjects(%s), actions(%s), resources(%s)", [data.library.parameters.subjects, data.library.parameters.actions, data.library.parameters.resources])
}