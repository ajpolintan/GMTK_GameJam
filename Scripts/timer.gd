extends Control

var time = 5.0
var stopped = false 


func _process(delta):
	if stopped:
		return
	time -= delta
	test()
	
func reset():
	time = 0.0 
	
func test():
	print(time)
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time / 60 
	var format_string = "%02d : %02d : %02d"
	var actual_string = format_string % [min,sec, msec]
	$Countdown.text = actual_string
	
	if (time < 1) :
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

	
