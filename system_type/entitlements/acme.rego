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
	msg := sprintf("HelloWorld parameters entered %s", [data.library.parameters.actions])
}


#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Invalid action"
# diagnostics:
#   - entz_object_check_actions
#   - action_exists
# description: >-
#   ACME : Matches requests where the input action is missing or is NOT contained
#   within the object model's user list.
#############################################################################
action_is_not_valid[msg] {
	# equivalent to 'not input.action in data.object.actions',
	#   but written this way to avoid requiring new OPAs
	count({1 | input.action == data.object.actions[_]}) == 0
	msg := sprintf("Action %s is not valid", [input.action])
}

action_is_not_valid[msg] {
	# input.action is undefined
	not input.action == input.action
	msg := "Action is not specified in the request"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Invalid user"
# diagnostics:
#   - entz_object_check_users
#   - subject_exists
# description: >-
#   ACME : Matches requests where the input subject is missing or is NOT contained
#   within the object model's user list.
#############################################################################
user_is_not_valid[msg] {
	not data.object.users[input.subject]
	msg := sprintf("User %s is not valid", [input.subject])
}

user_is_not_valid[msg] {
	not input.subject == input.subject
	msg := "No subject found in the input request"
}
