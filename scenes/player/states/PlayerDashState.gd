extends PlayerState
class_name PlayerDashState

## STATE: when the player is currently in the dash state
## Will automatically transition to MoveState after dash finishes

## How long the dash lasts for
@export var dash_time: float = 0.15
## What speed you dash at calculated by move_speed * dash_speed_mult
@export_range(1, 3) var dash_speed_mult: float = 2
var decel_rate: float
## If player should be allowed to jump immediately after a dash
## if they pressed jump during the dash. Set to true to disable this behaviour.
@export var disable_jump_buffer: bool = false

## To prevent dash_timeout from getting called after
## already transitioning to dash rebound
var already_transitioned := false
## Check if player was previously in air
## to prevent being able to dash jump from being stationary on floor
var was_in_air := false
var down_dashed := false
var last_wall_normal := 0
var dash_dir = 0

func calculate_dash_speed():
	return player.move_speed * dash_speed_mult

func enter():
	AudioManager.dash_sfx.play()
	
	was_in_air = in_air()
	already_transitioned = false
	down_dashed = false
	dash_dir = player.facing_dir
	
	if (Input.is_action_pressed("down") and was_in_air):
		#player.modulate = Color.PURPLE
		player.velocity.y = calculate_dash_speed() * dash_speed_mult
		down_dashed = true
	else:
		#player.velocity.x = dash_speed * player.facing_dir
		player.velocity.x = calculate_dash_speed() * dash_dir
		player.velocity.y = 0
	#decel_rate = absf(player.velocity.x / stopping_time)
	
	## If dashing in wrong direction from last wall, cancel speed
	if player.last_rebound_dir == -dash_dir:
		player.reset_speed_level()
		print("SPEED RESET: dash wrong dir from last wall")
		player.velocity.x = calculate_dash_speed() * dash_dir
	
	## Start dash timer
	get_tree().create_timer(dash_time).timeout.connect(on_dash_timeout)


var prev_vel
var phase_through = false
func physics_update(_delta: float):
	prev_vel = player.velocity
	player.move_and_slide()
	for i in range(player.get_slide_collision_count()):
		var coll = player.get_slide_collision(i).get_collider().get_parent()
		#print(coll.name)
		if coll is SpeedBarrierTile and coll.speed_level <= player.speed_level:
			coll.break_barrier()
			player.velocity = prev_vel
			phase_through = true
	# if breaking through barrier, early return to prevent rebound
	# NOTE: this code cant make player break a barrier and rebound in the same dash!
	if phase_through:
		return
	
	## conditions to transition into rebound
	# check for wall rebound first
	# must be on wall opposite to last wall contact
	if \
	(
		player.is_on_wall() and \
		sign(player.get_wall_normal().x) != player.last_rebound_dir
	) or \
	# these three conditions below check for a valid downward dash rebound
	(
		player.is_on_floor() and \
		Input.is_action_pressed("down") and \
		was_in_air
	):
		# if wall or floor rebound, then transition to rebound state
		already_transitioned = true
		transitioned.emit(self, "PlayerReboundState")
		
		

func exit():
	phase_through = false
	# so the player does not jump immediately if you press jump during a dash
	if disable_jump_buffer:
		player.jump_buffer_timer.stop()
	player.has_dash = false
	# reset back to move speed
	if not down_dashed:
		player.velocity.x = clampf(player.velocity.x, -player.move_speed, player.move_speed)

func on_dash_timeout():
	if not already_transitioned:
		transitioned.emit(self, "PlayerMoveState")
