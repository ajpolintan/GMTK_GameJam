extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var playerInBooster = false
var player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _on_body_entered(body: Node2D):
	if body.name == "Player":
		playerInBooster = true
		player = body
	
func _on_body_exited(body: Node2D) -> void:
	playerInBooster = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playerInBooster:
		player.launchRight()

		
