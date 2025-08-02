extends AnimatableBody2D
@onready var timer: Timer = $Timer
var up = true
var stopping = false
var velocity = 0
const speed = 2.5
const maxSpeed = 500

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
	global_position.y += velocity * delta
	
func _on_timer_timeout() -> void:
	if !stopping:
		stopping = true
	else:
		stopping = false
		up = !up
