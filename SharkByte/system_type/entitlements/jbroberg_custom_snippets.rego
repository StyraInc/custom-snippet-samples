package global.custom_snippet_samples.jbroberg.system_type.entitlements

#############################################################################
# version: v1.0
#
# This rego file contains example custom snippets.  The are intended to be used 
# as examples when creating your own custom snippets.  Each custom snippet shows
# a particular capability that can be used.  The majority of these capabilities
# are defined in the snippets metadata.  Snippets utilize the OPA standard mechanism
# for annotating rego rules.
#
#############################################################################

# charles could you please explain why we have these next few helper methods
object_users = data.object.users {
	true
} else = {} {
	true
}

object_resources = data.object.resources {
	true
} else = {} {
	true
}

object_has_all_attributes(object, attributes) {
	matches := [match |
		attr_value := attributes[attr_key]
		object[attr_key] == attr_value
		match := true
	]

	count(matches) == count(attributes)
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "JBROBERG: Custom Snippet-Button-Allow-Deny"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# policy:
#   schema:
#     decision:
#       oneOf:
#############################################################################
custom_snippet_button_allow_deny[msg] {
	msg := "JBROBERG: Custom Snippet-Button-Allow-Deny"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "JBROBERG: Custom Snippet-Button-Allow"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# policy:
#   schema:
#     decision:
#       oneOf:
#         - required:
#           - allowed
#############################################################################
custom_snippet_button_allow[msg] {
	msg := "JBROBERG: Custom Snippet-Button-Allow"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "JBROBERG: Custom Snippet-Button-Deny"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# policy:
#   schema:
#     decision:
#       oneOf:
#         - required:
#           - denied
#############################################################################
custom_snippet_button_Deny[msg] {
	msg := "JBROBERG: Custom Snippet-Button-Deny"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "JBROBERG: Custom Snippet-Button-None"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# policy:
#   schema:
#     decision:
#       oneOf: []
#############################################################################
custom_snippet_button_None[msg] {
	msg := "JBROBERG: Custom Snippet-Button-None"
}