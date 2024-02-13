class_name Main
extends Node2D

static var node:Node2D
static var Info:Array[TextEdit]
static var tonos : Array[Array] = [[32.7032, 34.6479, 36.7081, 38.8909, 41.2035, 43.6536, 46.2493, 48.9995, 51.9130, 55.0, 58.2705, 61.7354]]
static var hz:float = 0
const EQUATIONS:Array[String] = [
	"0",
	"sin(phase * TAU)",
	"2 * sin(phase * TAU) * exp(-3 * phase)"
	]


func _init():
	node = self
	for i in range(1, 5):
		tonos.append([])
		for j in tonos[0]:
			tonos[-1].append(j * (2**i))


func _ready():
	node = self
	for i in $Canvas/Infos.get_children():
		Info.append(i)
	_on_tono_value_changed($Canvas/Tono.value)

func _process(_delta):
	pass


func _on_tono_value_changed(value):
	$Canvas/Tono/Name.text = "C Cs D Ds E F Fs G Gs A As B".split(" ")[int(value) % 12] + " " + str(int(value)/12 + 1)
	$Canvas/Tono/Frequency.text = str(tonos[int(value) / 12][int(value) % 12])
	
	_on_frequency_text_changed($Canvas/Tono/Frequency.text)


func _on_frequency_text_changed(new_text):
	if new_text.is_valid_float():
		hz = new_text.to_float()






