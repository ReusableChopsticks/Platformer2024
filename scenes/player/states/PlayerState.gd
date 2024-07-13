extends State
class_name PlayerState

### An interface for player controls and common functions.

@onready var player: PlayerCharacter
@onready var sprite: Sprite2D

func _ready():
	player = $"../.."
	sprite = $"../../PlayerSprite"

# following the kinematics formula: next_v = curr_v + accel * delta_time * mult
# clamps to max fall speed
# also handles gravity multipliers for jump apex and fast falling
func apply_gravity(delta: float, multiplier: float = 1):
	if (player.velocity.y > 0 and player.velocity.y < player.jump_apex_range):
		multiplier *= player.jump_apex_mult
	if (player.velocity.y > player.jump_apex_range):
		multiplier *= player.fast_fall_mult
		
	player.velocity.y = minf(player.velocity.y + (player.gravity * delta * multiplier), player.max_fall_speed)

# @description: moves player and direction gets handled for you
# @@@ CONTRACT @@@
# @param weight: what to multiply the acceleration rate with, within range (0, infinity)
func move_x(delta: float, multiplier: float = 1):
	var direction = signf(Input.get_axis("left", "right"))
	if !direction:
		friction_x(delta, multiplier)
	
	var vel = player.velocity.x + (multiplier * player.move_accel * direction * delta)
	
	# apply counter force when moving in opposite direction
	if (direction and player.velocity.x and direction != signf(player.velocity.x)):
		vel += direction * player.move_speed * player.counter_dir_force_mult * delta
	
	player.velocity.x = clampf(vel, -player.move_speed, player.move_speed)

# applies a friction force against the current velocity of the player
func friction_x(delta: float, multiplier: float = 1):
	if (is_zero_approx(player.velocity.x)):
		# stop applying friction if the player has stopped
		return
	var dir = sign(player.velocity.x)
	if (dir == 1):
		player.velocity.x = maxf(0, player.velocity.x - (player.friction_decel * delta * multiplier))
	elif (dir == -1):
		player.velocity.x = minf(0, player.velocity.x + (player.friction_decel * delta * multiplier))

#region check player controls
func grounded():
	return player.is_on_floor()

func idle():
	return grounded and !Input.is_anything_pressed() and player.velocity == Vector2.ZERO

func in_air():
	return !player.is_on_ceiling() and !player.is_on_floor() and !player.is_on_wall()

func jump():
	# check if either grace or buffer is active
	if (Input.is_action_just_pressed("jump")):
		return player.jump_grace_timer.time_left > 0
	else:
		return player.jump_buffer_timer.time_left > 0 and player.is_on_floor()

func dash():
	if Input.is_action_just_pressed("dash"):
		return player.has_dash
	else:
		return player.dash_buffer_timer.time_left > 0 and player.has_dash

func wall():
	# player is only on a wall and is holding on to it
	return player.is_on_wall_only() and sign(Input.get_axis("left", "right")) == -player.get_wall_normal().x

func wall_jump():
	# check if either grace or buffer is active
	if (Input.is_action_just_pressed("jump")):
		return player.wall_jump_grace_timer.time_left > 0
	else:
		return player.jump_buffer_timer.time_left > 0 and player.is_on_wall_only()

func double_jump():
	#if !player.has_double_jump:
		#return false
	#
	#if (Input.is_action_just_pressed("jump")):
		## make a ray cast to see if player is close to ground
		#var result = player.ground_ray_cast.get_collider()
		## prevent double jump if player is close to the ground
		## so you don't double jump when you intend to just jump
		#if result is TileMap:
			#return false
		#
		## double jump when in the air
		#return player.jump_buffer_timer.time_left > 0 and in_air()
	#else:
		#return false
	if not player.has_double_jump:
		return false
		
	if (Input.is_action_just_pressed("jump") \
	  or player.jump_buffer_timer.time_left > 0) \
	  and in_air():
		## make a ray cast to see if player is close to ground
		var result = player.ground_ray_cast.get_collider()
		## prevent double jump if player is close to the ground
		## so you don't double jump when you intend to just jump
		return false if result is TileMap else true
#endregion
