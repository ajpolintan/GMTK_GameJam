extends Area2D
var ready_to_kill = false

func _ready():
	await get_tree().create_timer(0.1).timeout
	ready_to_kill = true

func _on_body_entered(body: Node2D):
	if ready_to_kill && body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
