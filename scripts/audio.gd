extends AudioStreamPlayer2D

var info:Array[TextEdit]
var hz:float
var increment:float
var frame := 1.0
var wavepoints := []
var phase:float = 0
var tester := Expression.new()
var executer := Expression.new()


func _ready():
	while $Equation/Graphic/Line.points.size() <= 500:
		$Equation/Graphic/Line.add_point($Equation/Graphic/Line.points[-1]+Vector2(1, 0), -1)
	
	executer.parse("0")
	tester.parse("0")
	
	for i in Main.node.EQUATIONS:
		$Equation/List.add_item(i)
	
	await Main.node._ready
	info = Main.Info
	
	play()
	
	process_mode = Node.PROCESS_MODE_INHERIT


func _process(delta):
	if phase == NAN: phase = 0
	frame = get_tree().get_frame()
	hz = Main.hz
	increment = hz / stream.mix_rate
	
	info[-1].text = "Variables:\nhz: {hz}\nincrement: {increment}\nframes: {frame}\nphase: {phase}".format( {"hz": hz, "increment": increment, "frame":frame, "phase": phase} )
	info[2].text = "FUNCs: reset()"
	info[1].text = "Executing: " + str(executer.execute([], self))
	info[0].text = "Testing: " + str(tester.execute([], self))
	
	if $Equation/Graphic/Select.is_pressed():
		$Equation/Graphic.position = Vector2i(get_global_mouse_position()*2)
	$Equation/Graphic.position = $Equation/Graphic.position.clamp(Vector2(-400, -400), Vector2(924, 668))
	$Equation.position = $Equation/Graphic.position+Vector2i(-512, 124)
	
	fill_buffer()
	draw_wave()


func fill_buffer():
	for i in range(get_stream_playback().get_frames_available()):
		
		var line_ecuation:float = executer.execute([], self)
		
		get_stream_playback().push_frame(Vector2.ONE * line_ecuation )
		
		phase = fmod(phase + increment, 1.0)
		
		if wavepoints.size() < 500:
			wavepoints.append(line_ecuation * Main.hz * 0.25)


var drawing := true
func draw_wave():
	if not drawing: return
	if not wavepoints.size() == 500: return
	
	for i in range(1, $Equation/Graphic/Line.points.size()-1):
		if wavepoints.is_empty(): return
		
		$Equation/Graphic/Line.points[i].y = wavepoints.pop_front()
	$Equation/Graphic/Point.text = str($Equation/Graphic/Line.points[250].y)


func _on_equation_text_submitted(new_text):
	tester.parse(new_text)
	if not typeof(tester.execute([], self, false)) == 3:
		return
	
	executer.parse(new_text)


func _on_list_item_selected(index):
	$Equation.text = $Equation/List.get_item_text(index)
	_on_equation_text_submitted($Equation.text)


func _on_check_button_toggled(toggled_on):
	AudioServer.set_bus_mute(0, false if toggled_on else true)


func _on_volume_value_changed(value):
	volume_db = int(value)


func _on_draw_toggled(toggled_on):
	drawing = toggled_on


func _on_mix_rate_slider_value_changed(value):
	Main.node.get_node("Canvas/MixRateSlider/MixRate").text = str(value)
	_on_mix_rate_text_changed(str(value))


func _on_mix_rate_text_changed(new_text):
	stream.mix_rate = int(new_text)


func reset():
	phase = 0










