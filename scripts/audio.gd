extends AudioStreamPlayer2D


var wavepoints:Array[float]
var increment:float
var phase:float
var frame:int
var hz:float


func _init(): stream.buffer_length = 0.15


func _process(delta): fill_buffer()


func fill_buffer():
	increment = hz / stream.mix_rate
	frame = get_tree().get_frame()
	
	for i in range(get_stream_playback().get_frames_available() ):
		var line_ecuation:float = Main.executer.execute( [], self)
		
		get_stream_playback().push_frame(Vector2.ONE * line_ecuation )
		
		phase = fmod(phase + increment, 1.0)
		
		if wavepoints.size() < 1024: wavepoints.append(line_ecuation)

