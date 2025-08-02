extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
var ready_to_kill = false
var spikeWalk

func _ready():
	await get_tree().create_timer(0.1).timeout
	ready_to_kill = true
	
func _on_spike_walk_selected():
	spikeWalk = true
	print("wazzaah")

func _on_body_entered(_body: Node2D):
	if ready_to_kill && !spikeWalk:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
