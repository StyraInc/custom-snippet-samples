package libraries.acme.snippets 

import data.library.parameters

import data.global.systemtypes["entitlements:1.0"].library.utils.v1 as utils

now := time.now_ns()
tz := object.get(parameters, "timezone", "UTC")

days_of_week := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
months_of_year := ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1.0
# title: "-12-- ACME: RBAC + Day/Month Snippet"
# description: >-
#   Matches requests that occured on specific days of the week AND within the 
#   specified month(s) AND where the subject has a path to the resource via RBAC. 
# details: >-
#   You can enter a month name like "April", a 3-letter abbreviation like "APR", or
#   a month number like "4". Month names/abbreviations are case-insensitive.
#   If no timezone is supplied, UTC is assumed. Timezones are in the IANA
#   format, a list of which can be found at:
#   https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# filePath:
# - systems/.*/policy/.*
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[obj]"
# schema:
#   parameters:
#     - name: "months"
#       label: Months
#       type: set_of_strings
#       placeholder: "Month of the Year"
#       items:
#         library: global/sharkbyte_custom_snippets/sharkbyte
#         query: months_of_year
#       default: ["Jan", "Feb"]
#     - name: "days"
#       label: Days
#       type: set_of_strings
#       placeholder: "Day of the Week"
#       items:
#         library: global/sharkbyte_custom_snippets/sharkbyte
#         query: days_of_week
#       default: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
#     - name: timezone
#       default: 'UTC'
#       type: string
#       placeholder: "IANA Timezone name (example: America/Los_Angeles)"
#     - name: ACME
#       default: '{acme}'
#       type: string
#       placeholder: "A new custom field"
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

# Welcome to the world of rego!
# The VSCode plugin provides a wealth of ready-made snippets to jump start your rego journey.
# Note that whether you have any snippets depends on the system type of the DAS system
# that you have connected to your currently loaded VSCode project with Styra Link.
# Use the "Styra Link: Initialize" command to set that up if you you have not already.
# Some useful links:
#    Rego Language https://www.openpolicyagent.org/docs/latest/policy-reference/
#    Styra DAS https://docs.styra.com/das



match_day_of_week[obj] { 
	print("sharkbyte custom snippet")
	print("params ", parameters)
	
	print("months")
	date := time.date([now, tz])
	month := date[1]
	some i
	string_to_month_number(parameters.months[i]) == month
	msg1 := sprintf("Month is %s", [month_number_to_string(month)])

	print("days")
	day_of_week := time.weekday([now, parameters.timezone])
	lower_day_of_week := lower(day_of_week)
	lower_day_of_week == lower(parameters.days[_])
	msg2 := sprintf("Weekday is %s", [day_of_week])

	print("rbac")
	data.global.systemtypes["entitlements:1.0"].library.policy.rbac.v1.any_role_allows_access[msg3]
	print("rbac OK")
	msg := sprintf("%s -AND- %s -AND- %s", [msg1, msg2, msg3])
	obj := {"message": msg}
}


match_month[obj] {
	#   The months must be provided as a list of strings with full month names,
	#   1-indexed month number, or 3 letter abbreviations. The months are
	#   case-insensitive.
	#
	#   Month name     Abbreviation     Number
	#   January        Jan              1
	#   February       Feb              2
	#   March          Mar              3
	#   April          Apr              4
	#   May            May              5
	#   June           Jun              6
	#   July           Jul              7
	#   August         Aug              8
	#   September      Sep              9
	#   October        Oct              10
	#   November       Nov              11
	#   December       Dec              12

	date := time.date([now, tz])
	month := date[1]
	some i
	string_to_month_number(parameters.months[i]) == month
	msg1 := sprintf("Request occurred in %s", [month_number_to_string(month)])

	data.global.systemtypes["entitlements:1.0"].library.policy.rbac.v1.any_role_allows_access[msg2]
	msg := sprintf("%s -AND- %s", [msg1, msg2])
	obj := {"message": msg}
}

# Helper rule to get the correct message to display for the
# match_requests_by_time rule.
match_requests_by_time_range_msg = msg {
	utils.object_contains_key(parameters, "start_time")
	utils.object_contains_key(parameters, "end_time")
	parameters.start_time != ""
	parameters.end_time != ""
	msg := sprintf("Request occurred between %s and %s", [parameters.start_time, parameters.end_time])
} else = msg {
	utils.object_contains_key(parameters, "start_time")
	parameters.start_time != ""
	msg := sprintf("Request occurred after %s", [parameters.start_time])
} else = msg {
	utils.object_contains_key(parameters, "end_time")
	parameters.end_time != ""
	msg := sprintf("Request occurred before %s", [parameters.end_time])
} else = msg {
	msg := "Request allowed because neither start_time nor end_time specified"
}

# Helper function to convert a string month, month number, or 3 letter
# abbreviation (see match_requests_by_month) to a 1-indexed month number.
string_to_month_number(s) = result {
	# This convoluted mess abuses the fact that:
	#
	#	m := sprintf("%s", [8])
	#
	# evaluates to: "%!s(int=8)"
	#
	# Technically this means that input strings which exactly match
	# this format, or which contain close parens may also be accepted.
	#
	# The point of this exercise is that we can accept either string or
	# integer arguments.
	l := replace(replace(trim(lower(sprintf("%s", [s])), " \t\n\r"), "%!s(int=", ""), ")", "")

	# Here, we abuse arithmetic operations to implement a case statement.
	# Observe that each product term multiplies by the month number (e.g.
	# the February clause multiplies by 2). The other part of each clause
	# is the sum booleans for that clause to "activate", cast to numbers
	# so we can do math on them. Observe that all boolean conditions are
	# mutually exclusive, so each product term is simply the month number
	# multiplied by either 0 or 1.
	#
	# Consider for example the case where s = "april". We would get:
	#
	#	1 * (0 + 0) + 2 * (0 + 0) + 3 * (0 + 0) + 4 * (1 + 0) + ... = 4
	#
	# Observe that in the may case, we must still guarantee each month
	# number is multipled by either 0 or 1, hence why only one conditional
	# is included.
	#
	result := (((((((((((1 * ((to_number(l == "january") + to_number(l == "jan")) + to_number(l == "1"))) + (2 * ((to_number(l == "february") + to_number(l == "feb")) + to_number(l == "2")))) + (3 * ((to_number(l == "march") + to_number(l == "mar")) + to_number(l == "3")))) + (4 * ((to_number(l == "april") + to_number(l == "apr")) + to_number(l == "4")))) + (5 * ((to_number(l == "may") + 0) + to_number(l == "5")))) + (6 * ((to_number(l == "june") + to_number(l == "jun")) + to_number(l == "6")))) + (7 * ((to_number(l == "july") + to_number(l == "jul")) + to_number(l == "7")))) + (8 * ((to_number(l == "august") + to_number(l == "aug")) + to_number(l == "8")))) + (9 * ((to_number(l == "september") + to_number(l == "sep")) + to_number(l == "9")))) + (10 * ((to_number(l == "october") + to_number(l == "oct")) + to_number(l == "10")))) + (11 * ((to_number(l == "november") + to_number(l == "nov")) + to_number(l == "11")))) + (12 * ((to_number(l == "december") + to_number(l == "dec")) + to_number(l == "12")))
}

month_number_to_string(num) = name {
	num == 1
	name = "January"
}

month_number_to_string(num) = name {
	num == 2
	name = "February"
}

month_number_to_string(num) = name {
	num == 3
	name = "March"
}

month_number_to_string(num) = name {
	num == 4
	name = "April"
}

month_number_to_string(num) = name {
	num == 5
	name = "May"
}

month_number_to_string(num) = name {
	num == 6
	name = "June"
}

month_number_to_string(num) = name {
	num == 7
	name = "July"
}

month_number_to_string(num) = name {
	num == 8
	name = "August"
}

month_number_to_string(num) = name {
	num == 9
	name = "September"
}

month_number_to_string(num) = name {
	num == 10
	name = "October"
}

month_number_to_string(num) = name {
	num == 11
	name = "November"
}

month_number_to_string(num) = name {
	num == 12
	name = "December"
}

# Helper function to convert a timestamp in ns to an RFC3339 string.
ns_to_rfc3339(ns) = result {
	date := time.date(ns)
	year := date[0]
	month := date[1]
	day := date[2]

	clock := time.clock(ns)
	hour := clock[0]
	minute := clock[1]
	seconds := clock[2]

	result := sprintf("%04d-%02d-%02dT%02d:%02d:%02d+00:00", [year, month, day, hour, minute, seconds])
}
