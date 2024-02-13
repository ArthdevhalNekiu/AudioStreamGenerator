class_name Main
extends Node2D


const EQUATIONS:Array[String] = [
	"0",
	"sin(phase * TAU)",
	"2 * sin(phase * TAU) * exp(-3 * phase)"
	]
static var tonos : Array[Array] = [[32.7032, 34.6479, 36.7081, 38.8909, 41.2035, 43.6536, 46.2493, 48.9995, 51.9130, 55.0, 58.2705, 61.7354]]
static var hz := 440.0
static var node:Node2D
static var tester := Expression.new()
static var executer := Expression.new()
static var info:Array[Label]


func _init():
	node = self
	for i in range(1, 5): tonos.append(tonos[0].map(func (j): return j * (2 ** i)))
	tester.parse("0")
	executer.parse(("0"))


func _ready():
	var lst:OptionButton = $Canvas/Frequency/Tone/List
	for i in tonos:
		for j in i:
			$Canvas/Frequency/Tone/List.add_item(["C", "Cs", "D", "Ds", "E", "F", "Fs", "G", "Gs", "A", "As", "B"][int(lst.item_count) % 12] + " " + str(int(lst.item_count) / 12 + 1))
	$Canvas/Frequency/Tone/List.selected = 45
	
	for i in $Canvas/Infos.get_children(): info.append(i)


func _process(delta):
	if get_tree().get_frame() % 60 == 0:
		screenshot()
	
	info[0].text = "Exc: " + str(executer.execute( [], $Audio) ) + "- Test: " + str(executer.execute( [], $Audio) )
	info[1].text = str(hz) + "-" + str($Audio.hz) + "-" + str($Audio.stream.mix_rate)
	info[2].text = str($Canvas/Frequency/Tone.value)
	info[3].text = ""


func _on_tone_value_change(value):
	$Canvas/Frequency.text = str(tonos[value / 12][int(value) % 12] )
	$Canvas/Frequency/Tone/List.selected = value
	
	_on_frequency_text_changed($Canvas/Frequency.text)


func _on_list_tones_selected(index):
	$Canvas/Frequency.text = str(tonos[index / 12][int(index) % 12] )
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


func _on_mix_rate_text_changed(new_text):
	if new_text.is_valid_int():
		$Canvas/MixRate/MixRateSlider.set_value_no_signal(int(new_text) )
		$Audio.stream.mix_rate = int(new_text)


func _on_mix_rate_slider_value_changed(value):
	$Canvas/MixRate.text = str(value)
	
	_on_mix_rate_text_changed(str(value))


func screenshot():
	var data := get_viewport().get_texture().get_image().data
	var img := Image.new()
	img.data = data
	img.save_png("res://images/img{num}.png".format( {"num": get_tree().get_frame() } ) )













