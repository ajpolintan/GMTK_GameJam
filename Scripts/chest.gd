extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var open = false

func _on_body_entered(body: Node2D):
	if !open:
		open = true
		animated_sprite.play("default")

func _on_animated_sprite_2d_animation_finished():
	print ("chest get!")
