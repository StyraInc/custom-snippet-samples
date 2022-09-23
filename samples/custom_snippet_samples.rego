package global.custom_snippet_samples.samples

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

# object_users and object_resources are defined in this way to guarantee they
# will never be undefined, even if data.object.{users,resources} is not
# defined.
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

# This checks that every attribute requested is present in the given object,
# and that it has the same values for all keys in the attributes object. This
# is essentially equivalent to object.subset() in newer OPA versions.
object_has_all_attributes(object, attributes) {
	matches := [match |
		attr_value := attributes[attr_key]
		object[attr_key] == attr_value
		match := true
	]

	count(matches) == count(attributes)
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "CUSTOM: Custom Snippet-Button-Allow-Deny"
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
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
custom_snippet_button_allow_deny[obj] {
	obj := {"message": "CUSTOM: Custom Snippet-Button-Allow-Deny"}
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "CUSTOM: Custom Snippet-Button-Allow"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   decision:
#     - type: toggle
#       label: Permission
#       toggles:
#       - key: allowed
#         value: true
#         label: Allow
#     - type: rego
#       key: entz
#       value: "set()"
#     - type: rego
#       key: message
#       value: "obj.message"
#############################################################################
custom_snippet_button_allow[obj] {
	obj := {"message": "CUSTOM: Custom Snippet-Button-Allow"}
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "CUSTOM: Custom Snippet-Button-Deny"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   decision:
#     - type: toggle
#       label: Permission
#       toggles:
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
custom_snippet_button_deny[obj] {
	obj := {"message": "CUSTOM: Custom Snippet-Button-Deny"}
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "CUSTOM: Custom Snippet-Button-None"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet is the most basic, just returning the "msg" to the requester
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   decision:
#     - type: rego
#       key: entz
#       value: "set()"
#     - type: rego
#       key: message
#       value: "obj.message"
#############################################################################
custom_snippet_button_none[obj] {
	obj := {"message": "CUSTOM: Custom Snippet-Button-None"}
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "CUSTOM: Custom Snippet-Params"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet asks the user to enter one parameter, the subjects (aka users).
#   It does not provide any guidance for those values.
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   parameters:
#     - name: subjects
#       type: set_of_strings
#       required: false
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
custom_snippet_params[obj] {
	obj := {"message": sprintf("CUSTOM: Custom Snippet-Params subjects(%s)", [data.library.parameters.subjects])}
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "CUSTOM: Custom Snippet-Params-with-hints-ordered"
# diagnostics:
#   - entz_object_check_actions
# description: >-
#   This custom snippet asks the users for 3 different parameters, subjects, actions, resources.
#   For each one of these parameters, it provides hints as to what the values are that the user should select from
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   parameters:
#     - name: subjects
#       type: set_of_strings
#       placeholder: "Match subjects"
#       required: false
#       items:
#         package: "completions"
#         query: "subjects"
#     - name: actions
#       type: set_of_strings
#       placeholder: "Match actions"
#       required: false
#       items:
#         package: "object"
#         query: "actions"
#     - name: resources
#       type: set_of_strings
#       placeholder: "Resource selector and dropdown"
#       required: false
#       "items":
#         package: "transform.snippet"
#         query: "resources"
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
custom_snippet_params_with_hints[obj] {
	obj := {"message": sprintf("CUSTOM: Custom Snippet-Params-with-Hints subjects(%s), actions(%s), resources(%s)", [data.library.parameters.subjects, data.library.parameters.actions, data.library.parameters.resources])}
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "CUSTOM: User has attributes (Copy of ABAC)"
# diagnostics:
#   - entz_object_check_users
#   - subject_exists
#   - subject_has_attributes
# description: >-
#   Matches requests where the user making a request has all of the selected attributes.
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   parameters:
#     - name: attributes
#       type: object
#       description: attribute
#       key:
#         placeholder: "Users attribute key"
#       value:
#         type: set_of_strings
#         placeholder: "Users attribute value"
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
custom_user_has_attributes[obj] {
	object_has_all_attributes(object_users[input.subject], data.library.parameters.attributes)
	msg := sprintf("User %s has attributes %v", [input.subject, data.library.parameters.attributes])
	entz := {
		"snippet": "custom_snippets/custom_user_has_attributes",
		"type": "attributes",
		"attributes": data.library.parameters.attributes,
	}
	obj := {
		"message": msg,
		"entz": entz,
	}
}
