extends Control

var time = 30
var level = 0
var stopped = false 

func _on_stop():
	stopped = true
func _on_go():
	stopped = false
	addScore()

func addScore():
	Global.score += 1
	update_score_label()

func update_score_label():
	$Score.text = "Score: %d" % Global.score

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
	
	if (time <= 0) :
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

	
