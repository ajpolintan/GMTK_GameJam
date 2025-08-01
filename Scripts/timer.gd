extends Control

var time = 100.0
var stopped = false 

func _on_stop():
	stopped = true
func _on_go():
	stopped = false

func _process(delta):
	if stopped:
		return
	time -= delta
	test()
	
func reset():
	time = 0.0 
	
func test():
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var minute = time / 60 
	var format_string = "%02d : %02d : %02d"
	var actual_string = format_string % [minute, sec, msec]
	$Countdown.text = actual_string
	
	if (time < 1) :
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

	
