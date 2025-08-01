extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
var ready_to_open = false

signal chestGet

func _ready():
	animated_sprite.stop()
	await get_tree().create_timer(0.1).timeout
	ready_to_open = true

func _on_body_entered(_body: Node2D):
	if ready_to_open:
		animated_sprite.play("opening")
		emit_signal("chestGet")
