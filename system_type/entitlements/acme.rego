package global.acme_snippets.system_type.entitlements

#############################################################################
# version: v1
#
# This rego file contains example custom snippets.  The are intended to be used 
# as examples when creating your own custom snippets.  Each custom snippet shows
# a particular capability that can be used.  The majority of these capabilities
# are defined in the snippets metadata.  Snippets utilize the OPA standard mechanism
# for annotating rego rules.
#
#############################################################################

# you need to import this library so that ..... @charles
import data.library.parameters 

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
# title: "ACME: Custom Snippet-Button-Allow-Deny"
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
	msg := "ACME: Custom Snippet-Button-Allow-Deny"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet-Button-Allow"
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
	msg := "ACME: Custom Snippet-Button-Allow"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet-Button-Deny"
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
	msg := "ACME: Custom Snippet-Button-Deny"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet-Button-None"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# policy:
#   rule:
#     type: rego
#     value: "obj := {{library-snippet}}"
#   schema:
#     decision:
#       oneOf: []
#############################################################################
custom_snippet_button_None[msg] {
	msg := "ACME: Custom Snippet-Button-None"
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet-Params"
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
#     actions:
#       type: array
#       title: "Match Actions"
#       items:
#         type: string
#       uniqueItems: true
#     resources:
#       type: array
#       title: "Resource selector and dropdown"
#       items:
#         type: string
#       uniqueItems: true
#############################################################################
custom_snippet_params[msg] {
	msg := sprintf("ACME: Custom Snippet-Params subjects(%s)", [data.library.parameters.subjects])
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: Custom Snippet-Params-with-hints"
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
custom_snippet_params_with_hints[msg] {
	msg := sprintf("ACME: Custom Snippet-Params-with-Hints subjects(%s), actions(%s), resources(%s)", [data.library.parameters.subjects, data.library.parameters.actions, data.library.parameters.resources])
}

#############################################################################
# METADATA: library-snippet
# version: v1
# title: "ACME: User has attributes (Copy of ABAC)"
# diagnostics:
#   - entz_object_check_users
#   - subject_exists
#   - subject_has_attributes
# description: >-
#   Matches requests where the user making a request has all of the selected attributes.
# schema:
#   type: object
#   properties:
#     attributes:
#       type: object
#       title: Attributes
#       patternNames:
#         title: "Key"
#       additionalProperties:
#         type: string
#         title: "Value"
#   additionalProperties: false
#   required:
#     - attributes
# policy:
#   rule:
#     type: rego
#     value: "{{library-snippet}}[obj]"
#   schema:
#     decision:
#       type: object
#       properties:
#         entz:
#           type: rego
#           value: "obj.entz"
#         message:
#           type: rego
#           value: "obj.message"
#       required:
#         - entz
#         - message
acme_user_has_attributes[obj] {
	object_has_all_attributes(object_users[input.subject], parameters.attributes)
	msg := sprintf("User %s has attributes %v", [input.subject, parameters.attributes])
	entz := {
		"snippet": "acme_snippets/acme_user_has_attributes",
		"type": "attributes",
		"attributes": parameters.attributes,
	}
	obj := {
		"message": msg,
		"entz": entz,
	}
}
