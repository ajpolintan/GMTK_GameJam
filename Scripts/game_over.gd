extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TotalScore.text = "Total Score: %d" % Global.score 
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_try_again_pressed() -> void:
	Global.score = 0
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_exit_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
