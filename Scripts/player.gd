extends CharacterBody2D
@onready var timer: Timer = $jumpTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_jump = $sfx_jump
@onready var sfx_skid = $sfx_skid

#physics vars
var jumping = false
var skid = false
var wallSlide = false
var wallJump = false
var wallTouch = false
var skidDir = 0
const ACCEL = 5.0
const DECEL = 4.0
const SPEED = 100.0
const DASHSPEED = 200.0
const JUMP_VELOCITY = -170.0
const WALLSPEED = 100
const GRAVITY = 20.0
const MAX_DOWN = 200

#powerups
var doubleJumpMax = 0
var doubleJump = 0
var speedMult = 1

#stop gaining upwards velocity when jump timer is out
func _on_timer_timeout():
	jumping = false
	

func _physics_process(_delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	#check if touching wall
	var wall_left = test_move(global_transform, Vector2(-1, 0))
	var wall_right = test_move(global_transform, Vector2(1, 0))
	if (wall_left || wall_right):
		wallTouch = true
	else: wallTouch = false
	
###################################################################################################
	#vertical movement
###################################################################################################
	
	# Add the gravity.
	#conditions: in the air, not in jumping state, not holding jump button
	if not is_on_floor() && !jumping && not Input.is_action_pressed("jump"):
		if velocity.y < 0: velocity.y = 0
		else: velocity.y = move_toward(velocity.y, MAX_DOWN, GRAVITY)

	# Handle jump.
	#when pressed: set jumping to true (allows full hop) and start timer; full hop ends when timer runs out
	if Input.is_action_just_pressed("jump") && (is_on_floor() || wallTouch || doubleJump > 0):
		#if the jump is triggered when in the air next to a wall, it's a walljump
		if wallTouch && not is_on_floor(): 
			wallJump = true
			doubleJump = doubleJumpMax
			
		#if the jump is triggered in the air without a wall, it's a doublejump
		elif not is_on_floor(): 
			doubleJump -= 1
			if direction > 0: animated_sprite.flip_h = false
			elif direction < 0: animated_sprite.flip_h = true
		
		#start full hop timer
		jumping = true
		timer.start()
		sfx_jump.play()

		velocity.y = JUMP_VELOCITY
	
	#contiuing to hold jump button causes upward velocity to remain constant (for full hop)
	elif Input.is_action_pressed("jump") && jumping:
		velocity.y = JUMP_VELOCITY
	
	#when full hop timer runs out, slowly decrease velocity (as opposed to cutting it straight to downward)
	elif Input.is_action_pressed("jump") && !jumping:
		velocity.y = move_toward(velocity.y, MAX_DOWN, GRAVITY)

	#if jump stops being pressed early, end jump period
	elif jumping: jumping = false
	
	#cut jump early if hitting ceiling
	if is_on_ceiling():
		jumping = false
		velocity.y = 20
	
	#wallslide if touching wall while descending
	if is_on_wall() && direction && (velocity.y > 0):
		velocity.y = WALLSPEED
		wallSlide = true
	#continue wallslide even if not actively holding toward wall
	elif wallSlide && (wall_left || wall_right) && (velocity.y > 0):
		velocity.y = WALLSPEED
		wallSlide = true
	else: wallSlide = false
	
	#reset doublejump
	if is_on_floor():
		doubleJump = doubleJumpMax
	
###################################################################################################
	#horizontal movement
###################################################################################################
	
	#set max speed, depending on if dash is held or if airborne
	var maxSpeed
	if Input.is_action_pressed("dash"): maxSpeed = DASHSPEED * speedMult
	else: maxSpeed = SPEED * speedMult
	if not is_on_floor() && (abs(velocity.x) > maxSpeed):
		maxSpeed = abs(velocity.x)
	
	#skid if changing direction when running at max speed
	if is_on_floor() && (direction * velocity.x < 0) && (abs(velocity.x) >= (DASHSPEED - 12) * speedMult):
		animated_sprite.play("skid")
		sfx_skid.play()
		skid = true
		skidDir = direction

	
	#allow for faster turnaround even if not skidding speed
	if (direction * velocity.x < 0) && (abs(velocity.x) < (DASHSPEED - 12) * speedMult):
		velocity.x = move_toward(velocity.x, (maxSpeed * direction), ACCEL)
	
	# move in direction, up to max speed
	if direction && !skid:
		velocity.x = move_toward(velocity.x, (maxSpeed * direction), ACCEL * speedMult)
	
	# slow down to stop when not pressing anything
	if !direction && !skid && is_on_floor(): 
		velocity.x = move_toward(velocity.x, 0, DECEL)
	
	#end skid state early if airborne or cancelling skid
	if not is_on_floor(): skid = false
	if direction != skidDir: skid = false
	
	#when skidding, slow down to a stop then gain speed in other direction
	if skid:
		velocity.x = move_toward(velocity.x, 0, DECEL * speedMult)
	if skid && velocity.x == 0:
		velocity.x = ((DASHSPEED - 50) * speedMult) * skidDir
		skid = false
	
	#upon walljump, move in the opposite direction of the wall
	if wallJump:
		velocity.x = ((DASHSPEED - 70) * speedMult) * get_wall_normal().x
	
###################################################################################################
	#Handle Animations
###################################################################################################
	
	if (velocity.x != 0) && is_on_floor() && !skid: 
		if direction > 0 || skid: animated_sprite.flip_h = false
		elif direction < 0: animated_sprite.flip_h = true
		if abs(velocity.x) > SPEED:
			animated_sprite.play("run")
		else:
			animated_sprite.play("walk")
	
	if velocity.x == 0 && !direction && is_on_floor():
		animated_sprite.play("idle")
		
	if velocity.y >= 0 && not is_on_floor():
		animated_sprite.play("airborne")
		
	if velocity.y < 0:
		animated_sprite.play("jumpAnim")
		
	if wallSlide:
		animated_sprite.play("wallSlide")
		if direction > 0: animated_sprite.flip_h = false
		elif direction < 0: animated_sprite.flip_h = true
		
	if wallJump:
		if get_wall_normal().x > 0: animated_sprite.flip_h = false
		else: animated_sprite.flip_h = true
		wallJump = false

	move_and_slide()
