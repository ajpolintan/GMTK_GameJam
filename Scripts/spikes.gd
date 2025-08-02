extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
var ready_to_kill = false

func _ready():
	await get_tree().create_timer(0.1).timeout
	ready_to_kill = true


func _on_body_entered(body: Node2D):
	if body.name == "Player" && ready_to_kill:
		body.hitSpike()
