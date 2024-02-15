extends CodeEdit

@export_category("Colors")
@export var base_type := Color(0.26, 1, 0.76)
@export var number := Color(0.63, 1, 0.87)
@export var string := Color(1, 0.93, 0.63)
@export var symbol := Color(0.74, 0.88, 1)
@export var function := Color(0.34, 0.7, 1)
@export var member_variable := Color(0.74, 0.88, 1)
@export var keyword := Color(1, 0.44, 0.52)
@export var control_flow_keyword := Color(1, 0.55, 0.8)


func _init():
	syntax_highlighter.number_color = number
	syntax_highlighter.symbol_color = symbol
	syntax_highlighter.function_color = function
	syntax_highlighter.member_variable_color = member_variable
	
	for i in "breakpoint var func const and in or static self extends class class_name static false true TAU PI INF NAN".split(" "):
		syntax_highlighter.keyword_colors.merge( {i: keyword} )
	
	for i in "for while if continue break match".split(" "):
		syntax_highlighter.keyword_colors.merge( {i: control_flow_keyword} )
	
	for i in range(26):
		syntax_highlighter.keyword_colors.merge( {type_string(i): base_type} )
	
	##???
	#syntax_highlighter.color_regions.merge( {"\" \"": string, "' '": string})
	
	ResourceSaver.save(syntax_highlighter, "res://scripts/code_syntax.tres")






