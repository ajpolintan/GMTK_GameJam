extends CharacterBody2D
@onready var jumpTimer: Timer = $jumpTimer
@onready var dashTimer: Timer = $dashTimer
@onready var dashCooldownTimer: Timer = $dashCooldownTimer
@onready var dashCancelTimer: Timer = $dashCancelTimer
@onready var boostTimer: Timer = $boostTimer
@onready var deathTimer: Timer = $deathTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_jump = $sfx_jump
@onready var sfx_skid = $sfx_skid
@onready var sfx_dash = $sfx_dash
@onready var sfx_death = $sfx_death

#physics vars
var is_stopped = false
var isDead = false
var lockAnim = false
var jumpLock = false
var jumping = false
var skid = false
var wallSlide = false
var wallJump = false
var wallTouch = false
var skidDir = 0
const ACCEL = 5.0
const DECEL = 3.0
const SPEED = 80.0
const RUNSPEED = 160.0
const DASHSPEED = 250.0
const BOOSTSPEED = 400.0
const JUMP_VELOCITY = -170.0
const WALLSPEED = 100
const GRAVITY = 20.0
const GLIDEVELOCITY = 50
const MAX_DOWN = 200

#powerups
var doubleJumpMax = 0
var doubleJump = 0
var speedMult = 1
var jumpMult = 1
var dashUnlock = false
var dashAvail = false
var dashing = false
var boostDashing = false
var dashCooldown = true
var dashDir = 0
var groundDash = 0
var jumpCancelDash = false
var jumpCancellable = false
var dashCancel = false
var glideUnlock = false
var gliding = false
var spikeBoots = false

func _on_stop():
	is_stopped = true
	velocity = Vector2.ZERO
	animated_sprite.play("idle")
func _on_go():
	is_stopped = false


###################################################################################################
#Jump funcs
###################################################################################################

func jumpProc(dir):
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jumpCheck(dir)
		
	#full hop
	elif  jumping:
		velocity.y = JUMP_VELOCITY * jumpMult
		
	#when full hop timer runs out, slowly decrease velocity (as opposed to cutting it straight to downward)
	elif !jumping:
		velocity.y = move_toward(velocity.y, MAX_DOWN, GRAVITY)
		
	if velocity.y > 0 && glideUnlock:
		velocity.y = GLIDEVELOCITY
		glideAnim()
	if velocity.y <= 0 && glideUnlock: glideEnd()
#end jumpProc


func jumpCheck(dir):
	if is_on_floor():
		jump()
	
	#if the jump is triggered when in the air next to a wall, it's a walljump
	elif wallTouch:
		wallJump = true
		doubleJump = doubleJumpMax
		jump()
	
	#if performing groundDash, make jump available
	elif groundDash && dashing:
		jump()
		
	#if the jump is triggered in the air without a wall, it's a doublejump
	elif doubleJump > 0: 
		doubleJump -= 1
		if dir > 0: 
			animated_sprite.flip_h = false
		elif dir < 0: 
			animated_sprite.flip_h = true
		doubleAnim()
		jump()
#end jumpCheck

#jump
func jump():
	jumping = true
	jumpTimer.start()
	sfx_jump.play()
	velocity.y = JUMP_VELOCITY * jumpMult
	jumpAnim()
	
#stop gaining upwards velocity when jump timer is out
func _on_timer_timeout():
	jumping = false
	endJump()
	
###################################################################################################
#Skid
###################################################################################################

func turnAroundProc(dir):
	#skid if changing direction when running at max speed	
	if is_on_floor() && !boostDashing && (abs(velocity.x) >= (RUNSPEED - 15) * speedMult):
		sfx_skid.play()
		skid = true
		skidDir = dir
		skidAnim()
	#allow for faster turnaround even if not skidding speed
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * 2)

func skidProc(dir):
	#end skid state early if airborne or cancelling skid
	if not is_on_floor() || dir != skidDir || dashing: 
		skid = false
		endSkid()
		return
		
	#when skidding, slow down to a stop then gain speed in other direction
	velocity.x = move_toward(velocity.x, 0, DECEL * speedMult)
	if skid && velocity.x == 0:
		velocity.x = ((RUNSPEED - 50) * speedMult) * skidDir
		skid = false
		endSkid()
###################################################################################################
#dash
###################################################################################################

#note:	dash cancel refers to the dash being cancelled with a jump, but not early enough to maintain speed
#		jump cancel dash refers to dash being cancelled early, so speed is maintained

func startDash(dir):
	if (dashAvail && dashCooldown):
		dashTimer.start()
		dashCooldownTimer.start()
		dashCancelTimer.start()
		sfx_dash.play()
		dashing = true
		jumpCancellable = true
		dashCooldown = false
		dashAvail = false
		dashCancel = false
		jumping = false
		skid = false
		endSkid()
		#store whether dash was started on ground
		if (is_on_floor()): groundDash = true
		else: groundDash = false
		
		#Determine direction of dash
		if wallSlide:
			dashDir = get_wall_normal().x
		elif dir:
			dashDir = dir
		else:
			if animated_sprite.flip_h == true:
				dashDir = -1
			else:
				dashDir = 1
		dashAnim()

func dash():
	if !jumping:
		velocity.y = 0
		velocity.x = (DASHSPEED * speedMult) * dashDir
	else:
		if jumpCancellable:
			jumpCancelDash = true
			dashing = false
			velocity.x = ((DASHSPEED + RUNSPEED) * speedMult / 2) * dashDir
		else:
			dashing = false
			dashCancel = true
			velocity.x = RUNSPEED * dashDir
		endDash()

#dash duration
func _on_dash_timer_timeout() -> void:
	dashing = false
	groundDash = false
	if !jumpCancelDash && (abs(velocity.x) > RUNSPEED):
		if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || dashCancel:
			velocity.x = RUNSPEED * dashDir
		else: velocity.x = 0
	else: jumpCancelDash = false
	dashCancel = false
	endDash()
	
#dash cooldown
func _on_dash_cooldown_timer_timeout() -> void:
	dashCooldown = true

#dash cancel window
func _on_dash_cancel_timer_timeout() -> void:
	jumpCancellable = false
	
###################################################################################################
#Interactables
###################################################################################################

func launchRight():
	if (is_on_floor() && !boostDashing):
		boostTimer.start()
		dashCooldownTimer.start()
		dashCancelTimer.start()
		sfx_dash.play()
		boostDashing = true
		dashCooldown = false
		dashAvail = false
		dashCancel = false
		jumping = false
		skid = false
		endSkid()
		#store whether dash was started on ground
		if (is_on_floor()): groundDash = true
		else: groundDash = false
		dashDir = 1
		boostAnim()
		
func boostDash():
	if !jumping:
		velocity.y = 0
		velocity.x = (BOOSTSPEED * speedMult) * dashDir
	else:
		boostDashing = false
		endDash()
		
func _on_boost_timer_timeout() -> void:
	boostDashing = false
	groundDash = false
	dashCancel = false
	endDash()

func hitSpike():
	if !spikeBoots:
		death()
		
func hitDeath():
	death()
		
func death():
	if !isDead:
		isDead = true
		is_stopped = true
		sfx_death.play()
		animated_sprite.play("death")
		deathTimer.start()
	
func _on_death_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

###################################################################################################
#Animations
###################################################################################################

func skidAnim():
	lockAnim = true
	if skidDir > 0: animated_sprite.flip_h = true
	else: animated_sprite.flip_h = false
	animated_sprite.play("skid")
func endSkid():
	lockAnim = false
	
func jumpAnim():
	if !jumpLock:
		jumpLock = true
		animated_sprite.play("jumpAnim")	
func doubleAnim():
	jumpLock = true
	animated_sprite.play("doubleJump")
func endJump():
	jumpLock = false
	
func dashAnim():
	lockAnim = true
	if dashDir > 0 || skid: animated_sprite.flip_h = false
	elif dashDir < 0: animated_sprite.flip_h = true
	animated_sprite.play("dash")
func boostAnim():
	lockAnim = true
	if dashDir > 0 || skid: animated_sprite.flip_h = false
	elif dashDir < 0: animated_sprite.flip_h = true
	animated_sprite.play("boostDash")
func endDash():
	lockAnim = false
	
func glideAnim():
	gliding = true
	animated_sprite.play("glide")
func glideEnd():
	gliding = false
##################################################################################################
#Physics
##################################################################################################

func _physics_process(_delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	#check if touching wall
	var wallLeft = test_move(global_transform, Vector2(-1, 0))
	var wallRight = test_move(global_transform, Vector2(1, 0))
	if (wallLeft || wallRight):
		wallTouch = true
	else: wallTouch = false
	
	#check if stopped
	if is_stopped:
		velocity = Vector2.ZERO
		return
		
	#reset abilities
	if is_on_floor() || wallSlide || wallJump:
		doubleJump = doubleJumpMax
		if dashUnlock: dashAvail = true
		wallJump = false
	
###################################################################################################
	#vertical movement
###################################################################################################
	
	# Add the gravity.
	if not is_on_floor() && !jumping && not Input.is_action_pressed("jump"):
		if velocity.y < 0: velocity.y = 0
		else: velocity.y = move_toward(velocity.y, MAX_DOWN, GRAVITY)
		endJump()
	
	#Handle jump
	if Input.is_action_pressed("jump"):
		jumpProc(direction)
	#if jump stops being pressed early, end jump period
	else:
		if gliding: glideEnd()
		if jumping: jumping = false
	
	
	#cut jump early if hitting ceiling
	if is_on_ceiling() && jumping:
		jumping = false
		velocity.y = 20
	
	#wallslide if touching wall while descending
	if is_on_wall() && direction && (velocity.y > 0):
		velocity.y = WALLSPEED
		wallSlide = true
	#continue wallslide even if not actively holding toward wall
	elif wallSlide && wallTouch && (velocity.y > 0):
		velocity.y = WALLSPEED
		wallSlide = true
	else: wallSlide = false
	
###################################################################################################
	#horizontal movement
###################################################################################################
	
	#set max speed, depending on if run is held or if airborne
	var maxSpeed
	if Input.is_action_pressed("run"): maxSpeed = RUNSPEED * speedMult
	else: maxSpeed = SPEED * speedMult
	if not is_on_floor() && (abs(velocity.x) > maxSpeed):
		maxSpeed = abs(velocity.x)
		
	# move in direction, up to max speed
	if direction && !skid:
		velocity.x = move_toward(velocity.x, (maxSpeed * direction), ACCEL * speedMult)
	
	# slow down to stop when not pressing anything
	if !direction && !skid && is_on_floor(): 
		velocity.x = move_toward(velocity.x, 0, DECEL)
	
	#turnaround
	if (direction * velocity.x < 0) && !dashing:
		turnAroundProc(direction)
	if skid && !dashing:
		skidProc(direction)
		
	if Input.is_action_just_pressed("dash") && dashCooldown && dashAvail:
		startDash(direction)
		
	if dashing: dash()
	if boostDashing: boostDash()
	
	#upon walljump, move in the opposite direction of the wall
	if wallJump:
		velocity.x = ((RUNSPEED - 50) * speedMult) * get_wall_normal().x

	move_and_slide()
	
###################################################################################################
	#Handle Animations
###################################################################################################

	if !lockAnim:
		if is_on_floor():
			if direction > 0: animated_sprite.flip_h = false
			elif direction < 0: animated_sprite.flip_h = true
			if (velocity.x == 0):
				animated_sprite.play("idle")
			elif (abs(velocity.x) <= SPEED):
				animated_sprite.play("walk")
			else:
				animated_sprite.play("run")
			
		elif !jumpLock && !gliding:
			animated_sprite.play("airborne")
			
		if wallSlide:
			animated_sprite.play("wallSlide")
			if direction > 0: animated_sprite.flip_h = false
			elif direction < 0: animated_sprite.flip_h = true
		
		if wallJump:
			if get_wall_normal().x > 0: animated_sprite.flip_h = false
			else: animated_sprite.flip_h = true
