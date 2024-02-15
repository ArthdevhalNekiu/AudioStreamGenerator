class_name Main
extends Node2D


static var frequency := [32.7032, 34.6479, 36.7081, 38.8909, 41.2035, 43.6536, 46.2493, 48.9995, 51.9130, 55.0, 58.2705, 61.7354]
static var executer := Expression.new()
static var tester := Expression.new()
static var node:Node2D
static var hz:float
const EQUATION := [
	"0",
	"sin(phase * TAU)",
	"2 * sin(phase * TAU) * exp(-3 * phase)",
	"2 * sin(phase * TAU) * exp(-3 * phase) * ( (frame  % 50) + 10) * phase)"
	]


func _init():
	node = self

	tester.parse("0")
	executer.parse(("0") )

	for i in range(5 * 12 - 12): frequency.append(frequency[i % 12] * (2 ** ( (i / 12) + 1) ) )


func _ready():
	var tone := ["C", "Cs", "D", "Ds", "E", "F", "Fs", "G", "Gs", "A", "As", "B"]
	for i in range(frequency.size()):
		$Canvas/Frequency/Tone/List.add_item(tone[i % 12] + " " + str(i / 12 + 1) )
	$Canvas/Frequency/Tone/List.selected = frequency.size() / 2

	$Canvas/Frequency/Tone.max_value = frequency.size() - 1
	$Canvas/Frequency/Tone.value = frequency.size() / 2
	
	$Canvas/MixRate/MixRateSlider.max_value = 44100
	$Canvas/MixRate/MixRateSlider.min_value = 5
	$Canvas/MixRate/MixRateSlider.value = 22050
	$Canvas/MixRate/MixRateSlider.step = 5
	
	$Canvas/MixRate.virtual_keyboard_type = 2


func _process(delta):
	if false and get_tree().get_frame() % 60 == 0:
		screenshot()

	$Canvas/Info.text = "\nFrame: {Frame}\nTesting: {Test}\nExecuting: {Exc}\nMain-hz: {Mhz}\nMute: {Mute}\nVolume_db: {Vol}\n\nAudio-hz: {Ahz}\nAudio-MixRate: {AMR}\nPhase: {Phase}\nIncrement: {Inc}\n\nDrawPoints: {DP} / {LP}\n\nVariables:\nphase : Float\nframe : Int\nhz : Float\nincrement : Float\nwavepoints : Array[Float]".format( 
		{"Frame": get_tree().get_frame(), "Test": tester.execute( [], $Audio, false), "Exc": executer.execute( [], $Audio, false), "Mhz": hz, "Mute": AudioServer.is_bus_mute(0), "Vol": $Canvas/Sound/Volume.value, "Ahz": $Audio.hz, "AMR": $Audio.stream.mix_rate, "DP": $Audio.wavepoints.size(), "LP": $Graphic/Window/HLine.points.size(), "Phase": $Audio.phase, "Inc": $Audio.increment} )


func _on_tone_value_change(value):
	$Canvas/Frequency.text = str(frequency[value] )
	$Canvas/Frequency/Tone/List.selected = value

	_on_frequency_text_changed($Canvas/Frequency.text)


func _on_list_tones_selected(index):
	$Canvas/Frequency.text = str(frequency[index] )
	$Canvas/Frequency/Tone.set_value_no_signal(index)

	_on_frequency_text_changed($Canvas/Frequency.text)


func _on_frequency_text_changed(new_text):
	if new_text.is_valid_float():
		hz = new_text.to_float()
		$Audio.hz = hz


func _on_sound_toggled(toggled_on): AudioServer.set_bus_mute(0, false if toggled_on else true)


func _on_volume_value_changed(value): $Audio.volume_db = value


func _on_mix_rate_slider_value_changed(value):
	$Canvas/MixRate.text = str(value)
	
	_on_mix_rate_text_changed(str(value))


func _on_mix_rate_text_changed(new_text):
	if new_text.is_valid_int() and int(new_text) > 0:
		$Canvas/MixRate/MixRateSlider.set_value_no_signal(int(new_text) )
		$Audio.stream.mix_rate = int(new_text)


func screenshot():
	var data := get_viewport().get_texture().get_image().data
	var img := Image.new()
	img.data = data
	img.save_png("res://images/img{num}.png".format( {"num": get_tree().get_frame() } ) )

