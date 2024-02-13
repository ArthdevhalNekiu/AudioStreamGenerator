extends Node2D


func _ready():
	for i in Main.node.EQUATIONS: $Equation/List.add_item(i)
	
	for i in range(500): $Window/HLine.add_point(Vector2.RIGHT * i)


func _process(delta):
	if $Window/Select.is_pressed():
		$Window.position = get_global_mouse_position() * 2
	$Window.position = $Window.position.clamp(Vector2i.ONE * -250, Vector2i(774, 518) )
	$Equation.position = Vector2($Window.position) + Vector2(-512, 128)
	
	draw_wave()


var drawing := true
func draw_wave():
	if not drawing: return
	
	for i in range($Window/HLine.points.size()):
		if  Main.node.get_node("Audio").wavepoints.is_empty(): return
		
		$Window/HLine.points[i].y =  Main.node.get_node("Audio").wavepoints.pop_front() * Main.hz * 0.25
		$Window/Zero.text = str($Window/HLine.points[$Window/HLine.points.size() / 2].y)


func _on_drawing_toggled(toggled_on):
	drawing = toggled_on


func _on_list_equation_selected(index):
	$Equation.text = $Equation/List.get_item_text(index)
	$Equation.emit_signal("text_submitted", $Equation.text)
	


func _on_equation_text_submitted(new_text):
	Main.tester.parse(new_text)
	if not typeof(Main.tester.execute( [], Main.node.get_node("Audio"), false) ) == 3:
		return
	
	Main.executer.parse(new_text)










