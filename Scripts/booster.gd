extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play()
	
func _on_body_entered(body: Node2D):
	if body.name == "Player":
		body.launchRight()
