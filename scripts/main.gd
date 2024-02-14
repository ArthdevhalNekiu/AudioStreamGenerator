class_name Main
extends Node2D


static var node:Node2D
static var info:Array[Label]
static var tester := Expression.new()
static var executer := Expression.new()

const EQUATION:Array[String] = [
	"0",
	"sin(phase * TAU)",
	"2 * sin(phase * TAU) * exp(-3 * phase)",
	"2 * sin(phase * TAU) * exp(-3 * phase) * ( (frame  % 50) +10) * phase)"
	]

static var frequency : Array[Array] = [ [32.7032, 34.6479, 36.7081, 38.8909, 41.2035, 43.6536, 46.2493, 48.9995, 51.9130, 55.0, 58.2705, 61.7354] ]
static var hz := 440.0


func _init():
	node = self
	
	for i in range(1, 5): frequency.append(frequency[0].map(func (j): return j * (2 ** i) ) )
	
	tester.parse("0")
	executer.parse(("0") )


func _ready():
	var list:OptionButton = $Canvas/Frequency/Tone/List
	var tone := ["C", "Cs", "D", "Ds", "E", "F", "Fs", "G", "Gs", "A", "As", "B"]
	for i in range(frequency.size()):
		for j in range(frequency[i].size()):
			list.add_item(tone[int(list.item_count) % 12] + " " + str(int(list.item_count) / 12 + 1) )
	list.selected = 45
	
	for i in $Canvas/Infos.get_children(): info.append(i)


func _process(delta):
	if false and get_tree().get_frame() % 60 == 0:
		screenshot()
	
	info[0].text = "Exc: {exc} - Test: {test}".format({"exc": executer.execute( [], $Audio),"test": tester.execute( [], $Audio) } )
	info[1].text = "Hz: {hz} - Ahz: {Ahz} - Amr: {Amr}".format({"hz": hz, "Ahz": $Audio.hz, "Amr": $Audio.stream.mix_rate})
	info[2].text = "Tone: " + str($Canvas/Frequency/Tone.value)
	info[3].text = "WP: {wp} / {lp}".format( {"wp": $Audio.wavepoints.size(), "lp": $Graphic/Window/HLine.points.size() } )
	info[4].text = "Phase: {phase} \nIncrement: {inc}".format( {"phase": $Audio.phase, "inc": $Audio.increment})

func _on_tone_value_change(value):
	$Canvas/Frequency.text = str(frequency[value / 12][int(value) % 12] )
	$Canvas/Frequency/Tone/List.selected = value
	
	_on_frequency_text_changed($Canvas/Frequency.text)


func _on_list_tones_selected(index):
	$Canvas/Frequency.text = str(frequency[index / 12][int(index) % 12] )
	$Canvas/Frequency/Tone.set_value_no_signal(index)
	
	_on_frequency_text_changed($Canvas/Frequency.text)


func _on_frequency_text_changed(new_text):
	if new_text.is_valid_float():
		hz = new_text.to_float()
		$Audio.hz = hz


func _on_sound_toggled(toggled_on):
	AudioServer.set_bus_mute(0, false if toggled_on else true)


func _on_volume_value_changed(value):
	$Audio.volume_db = value


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













