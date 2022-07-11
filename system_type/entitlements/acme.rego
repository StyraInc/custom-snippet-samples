package global.acme_snippets.system_type.entitlements

import data.library.parameters

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet 1"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
#############################################################################
cusom_snippet_1[msg] {
	msg := "ACME: Custom Snippet 1"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet 2"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This is the ACME hello world snippet that shows the basic facility for a
#   snippet with parameters, and a silly message being returned.
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
#       title: "Resource selector"
#       items:
#         type: string
#       uniqueItems: true
#       "hint:items":
#         package: "transform.snippet"
#         query: "resources"
#############################################################################
cusom_snippet_2[msg] {
	msg := sprintf("ACME: Custom Snippet 2 parameters %s", [data.library.parameters.actions])
}

