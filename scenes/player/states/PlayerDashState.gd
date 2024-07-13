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

func enter():
	was_in_air = in_air()
	already_transitioned = false
	var dash_speed = player.move_speed * dash_speed_mult
	if (Input.is_action_pressed("down")):
		player.velocity.y = dash_speed * dash_speed_mult
	else:
		#player.velocity.x = dash_speed * player.facing_dir
		player.velocity.x = player.facing_dir * dash_speed
		player.velocity.y = 0
	#decel_rate = absf(player.velocity.x / stopping_time)
	get_tree().create_timer(dash_time).timeout.connect(on_dash_timeout)
	
	
func physics_update(_delta: float):
	player.move_and_slide()
	
	## conditions to transition into rebound
	# check for wall rebound first
	if player.is_on_wall() or \
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
	# so the player does not jump immediately if you press jump during a dash
	if disable_jump_buffer:
		player.jump_buffer_timer.stop()
	player.has_dash = false
	player.velocity.x = player.facing_dir * player.move_speed

func on_dash_timeout():
	if not already_transitioned:
		transitioned.emit(self, "PlayerMoveState")
