extends Area2D

func _ready():
	pass

func _on_body_entered(_body: Node2D):
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
