package global.snippets.system_type.entitlements

import data.library.parameters
#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Invalid action"
# diagnostics:
#   - entz_object_check_actions
#   - action_exists
# description: >-
#   Matches requests where the input action is missing or is NOT contained
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
#   Matches requests where the input subject is missing or is NOT contained
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
