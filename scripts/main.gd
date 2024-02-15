extends Node2D


var frequency := [32.7032, 34.6479, 36.7081, 38.8909, 41.2035, 43.6536, 46.2493, 48.9995, 51.9130, 55.0, 58.2705, 61.7354]
var executer := Expression.new()
var tester := Expression.new()
var hz:float = 0
var equations := [
	"0",
	"3 * sin(phase * TAU)",
	"3 * sin(phase * TAU) * exp(-3 * phase)",
	"0.25 * sin(phase * TAU) * exp(-1 * phase) * ( (frame  % 50) + 10) * phase"
	]


func _init():
	tester.parse("0")
	executer.parse(("0") )
	
	for i in range(5 * 12 - 12): frequency.append(frequency[int(i) % 12] * (2 ** ( (i / 12) + 1) ) )


func _ready():
	for i in equations:
		$Equations.add_item(i)
	
	var tones := ["C", "Cs", "D", "Ds", "E", "F", "Fs", "G", "Gs", "A", "As", "B"]
	for i in range(frequency.size()):
		$Control/Frequency/Tone/List.add_item(tones[i % 12] + " " + str(i / 12 + 1) )
	$Control/Frequency/Tone/List.selected = frequency.size() / 2
	$Control/Frequency/Tone.max_value = frequency.size() - 1
	$Control/Frequency/Tone.value = frequency.size() / 2


func _process(delta):
	$Info.text = "Frame: {Frame}\nTesting: {Test}\nExecuting: {Exc}\nMain-hz: {Mhz}\nMute: {Mute} - Volume_db: {Vol}\n\nAudio-hz: {Ahz}\nAudio-MixRate: {AMR}\nPhase: {Phase}\nIncrement: {Inc}\n\nDrawPoints: {DP} / {LP}\n\nVariables:\nphase : Float\nframe : Int\nhz : Float\nincrement : Float\nwavepoints : Array[Float]".format( 
		{"Frame": get_tree().get_frame(), "Test": tester.execute( [], $Audio, false), "Exc": executer.execute( [], $Audio, false), "Mhz": hz, "Mute": AudioServer.is_bus_mute(0), "Vol": $Control/Sound/Volume.value, "Ahz": $Audio.hz, "AMR": $Audio.stream.mix_rate, "DP": $Audio.wavepoints.size(), "LP": $Graphic/HLine.points.size(), "Phase": $Audio.phase, "Inc": $Audio.increment} )


func screenshot():
	var data := get_viewport().get_texture().get_image().data
	var img := Image.new()
	img.data = data
	img.save_png("res://images/img{num}.png".format( {"num": get_tree().get_frame() } ) )


func _on_equations_item_selected(index):
	$Equation.text = "\n" + $Equations.get_item_text(index) + "\n"
	_on_execute_button_up()


func _on_execute_button_up():
	tester.parse($Equation.text)
	if typeof(tester.execute( [], $Audio, false) == 3) and tester.get_error_text() == "":
		executer.parse($Equation.text)


func _on_volume_value_changed(value): $Audio.volume_db = value


func _on_frequency_text_changed(new_text):
	if new_text.is_valid_float() and new_text.to_float() > 0:
		hz = new_text.to_float()
		$Audio.hz = hz


func _on_tone_value_changed(value):
	$Control/Frequency.text = str(frequency[value] )
	$Control/Frequency/Tone/List.selected = value
	_on_frequency_text_changed($Control/Frequency.text)


func _on_list_tones_selected(index):
	$Control/Frequency.text = str(frequency[index] )
	$Control/Frequency/Tone.set_value_no_signal(index)
	_on_frequency_text_changed($Control/Frequency.text)


func _on_mix_rate_text_changed(new_text):
	if new_text.is_valid_int() and int(new_text) > 0:
		$Control/MixRate/MixRateSlider.set_value_no_signal(int(new_text) )
		$Audio.stream.mix_rate = int(new_text)


func _on_mix_rate_slider_value_changed(value):
	$Control/MixRate.text = str(value)
	_on_mix_rate_text_changed($Control/MixRate.text)


func _on_sound_toggled(toggled_on): AudioServer.set_bus_mute(0, not toggled_on)
