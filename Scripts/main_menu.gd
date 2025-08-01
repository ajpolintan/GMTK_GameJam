extends Control

@onready var sfx_select = $Select

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level()
	pass # Replace with function body.


func _on_start_pressed() -> void:
	print("Start pressed")
	sfx_select.play()
	Global.score = 0
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	pass # Replace with function body.


func _on_options_pressed() -> void:
	print("Settings pressed")
	sfx_select.play()


	pass # Replace with function body.


func _on_quit_pressed() -> void:
	sfx_select.play()
	print("Exit pressed")
	get_tree().quit()

	pass # Replace with function body.
