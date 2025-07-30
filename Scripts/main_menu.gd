extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	print("Start pressed")
	get_tree().change_scene_to_file("res://JakeTest.tscn")
	pass # Replace with function body.


func _on_options_pressed() -> void:
	print("Settings pressed")

	pass # Replace with function body.


func _on_quit_pressed() -> void:
	print("Exit pressed")
	get_tree().quit()

	pass # Replace with function body.
