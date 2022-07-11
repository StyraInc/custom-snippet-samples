package global.acme_snippets.system_type.entitlements

import data.library.parameters


#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Hello World Snippet"
# diagnostics:
#   - entz_object_check_actions
#   - action_exists
# description: >-
#   This is the ACME hello world snippet that shows the basic facility for a
#   snippet with no parameters, and a silly message being returned.
#############################################################################
test[msg] {
	msg := "Hello World"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Hello World Snippet w/parameter"
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
test[msg] {
	msg := sprintf("Hello World parameters entered %s", [data.library.parameters.actions])
}

