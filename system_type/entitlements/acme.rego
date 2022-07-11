package global.acme_snippets.system_type.entitlements

import data.library.parameters

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet 1"
# diagnostics:
#   - entz_object_check_actions
#   - action_exists
# description: >-
#   This is the ACME hello world snippet that shows the basic facility for a
#   snippet with no parameters, and a silly message being returned.
#############################################################################
cusom_snippet_1[msg] {
	msg := "Hello World"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet 2"
# diagnostics:
#   - entz_object_check_actions
#   - action_exists
# description: >-
#   This is the ACME hello world snippet that shows the basic facility for a
#   snippet with parameters, and a silly message being returned.
# schema:
#   type: object
#   properties:
#     actions:
#       type: array
#       title: "Match Actions"
#       items:
#         type: string
#       uniqueItems: true
#       "hint:items":
#         package: "object"
#         query: "actions"
#############################################################################
cusom_snippet_2[msg] {
	msg := sprintf("Hello World parameters entered %s", [data.library.parameters.actions])
}

