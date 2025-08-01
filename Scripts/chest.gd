extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
var open
var ready_to_open = false

signal chestGet

func _ready():
	await get_tree().create_timer(0.1).timeout
	ready_to_open = true

func _on_body_entered(_body: Node2D):
	if ready_to_open && !open:
		open = true
		animated_sprite.play("opening")
		timer.start()

func _on_timer_timeout() -> void:
	open = false
	animated_sprite.stop()
	emit_signal("chestGet")
