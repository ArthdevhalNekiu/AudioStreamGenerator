extends AudioStreamPlayer2D


var frame := 0
var hz := 440.0
var increment = hz / stream.mix_rate
var wavepoints := []
var phase:float = 0


func _process(delta):
	fill_buffer()


func fill_buffer():
	frame = get_tree().get_frame()
	increment = hz / stream.mix_rate
	
	for i in range(get_stream_playback().get_frames_available() ):
		var line_ecuation:float = Main.executer.execute( [], self)
		
		get_stream_playback().push_frame(Vector2.ONE * line_ecuation )
		
		phase = fmod(phase + increment, 1.0)
		
		if wavepoints.size() < 500:
			wavepoints.append(line_ecuation)
