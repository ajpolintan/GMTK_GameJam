extends AnimatableBody2D
@onready var timer: Timer = $Timer
var up = false
var stopping = false
var velocity = 0
const speed = 2.5
const maxSpeed = 500
var cooldown = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !stopping:
		if up:
			velocity = move_toward(velocity, -maxSpeed, speed)
		else:
			velocity = move_toward(velocity, maxSpeed, speed)
	else: 
		velocity = move_toward(velocity, 0, speed)
	if cooldown:
		global_position.y += velocity * delta
		cooldown = false
	else:
		cooldown = true
	
func _on_timer_timeout() -> void:
	if !stopping:
		stopping = true
	else:
		stopping = false
		up = !up
