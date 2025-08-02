extends Area2D
var spikeWalk = false
var ready_to_kill = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	ready_to_kill = true
	
func _on_spike_walk_selected():
	spikeWalk = true

func _on_body_entered(_body: Node2D):
	print("bang!")
	if ready_to_kill && !spikeWalk:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
