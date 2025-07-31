extends CharacterBody2D
@onready var timer: Timer = $jumpTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var jumping = false
const ACCEL = 10.0
const SPEED = 180.0
const JUMP_VELOCITY = -170.0
const GRAVITY = 20.0
const MAX_DOWN = 200

func _on_timer_timeout():
	jumping = false
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() && !jumping && not Input.is_action_pressed("jump"):
		if velocity.y < -50: velocity.y = -50
		else: velocity.y = move_toward(velocity.y, MAX_DOWN, GRAVITY)

	# Handle jump.
	if Input.is_action_just_pressed("jump") && is_on_floor():
		jumping = true
		timer.start()
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("jump") && jumping:
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("jump") && !jumping:
		velocity.y = move_toward(velocity.y, MAX_DOWN, GRAVITY)
	elif jumping: jumping = false
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = move_toward(velocity.x, (SPEED * direction), ACCEL)
	velocity.x = move_toward(velocity.x, 0, 5)
	
	
	#Handle Animations
	
	if (direction > 0) && is_on_floor(): 
		animated_sprite.flip_h = false
		animated_sprite.play("run")
	if direction < 0 && is_on_floor(): 
		animated_sprite.flip_h = true
		animated_sprite.play("run")
	
	if velocity.x == 0 && !direction && is_on_floor():
		animated_sprite.play("idle")
		
	if velocity.y >= 0 && not is_on_floor():
		animated_sprite.play("airborne")
		
	if velocity.y < 0:
		animated_sprite.play("jumpAnim")

	move_and_slide()
