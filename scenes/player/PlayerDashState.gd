extends PlayerState
class_name PlayerDashState

## STATE: when the player is currently in the dash state
## Will automatically transition to MoveState after dash finishes

## How long the dash lasts for
@export var dash_time: float = 0.15
## What speed you dash at calculated by move_speed * dash_speed_mult
@export_range(1, 3) var dash_speed_mult: float = 2
var decel_rate: float

var already_transitioned = false

func enter():
	already_transitioned = false
	var dash_speed = player.move_speed * dash_speed_mult
	if (Input.is_action_pressed("down")):
		player.velocity.y = dash_speed
	else:
		#player.velocity.x = dash_speed * player.facing_dir
		player.velocity.x = player.facing_dir * dash_speed
		player.velocity.y = 0
	#decel_rate = absf(player.velocity.x / stopping_time)
	get_tree().create_timer(dash_time).timeout.connect(on_dash_timeout)
	
	
func physics_update(_delta: float):
	player.move_and_slide()
	if player.is_on_wall() or (player.is_on_floor() and Input.is_action_pressed("down")):
		already_transitioned = true
		transitioned.emit(self, "PlayerReboundState")
		

func exit():
	# so the player does not jump immediately if you press jump during a dash
	player.jump_buffer_timer.stop()
	player.has_dash = false

func on_dash_timeout():
	if not already_transitioned:
		print("dash timeout")
		transitioned.emit(self, "PlayerMoveState")
