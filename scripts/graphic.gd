extends Node2D


func _ready():
	for i in range(512): $HLine.add_point(Vector2.RIGHT * 2 * i)


func _process(delta):
	draw_wave()


func draw_wave():
	if not get_parent().get_node("Audio").wavepoints.size() >= 512: return
	
	for i in range($HLine.points.size() ):
		$HLine.points[i].y = get_parent().get_node("Audio").wavepoints.pop_front() * get_parent().hz * 0.125
		$Zero.text = str($HLine.points[$HLine.points.size() / 2].y)
