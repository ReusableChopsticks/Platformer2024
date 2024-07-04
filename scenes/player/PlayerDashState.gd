extends PlayerState
class_name PlayerDashState

## STATE: when the player is currently in the dash state
## Will automatically transition to MoveState after dash finishes

## How long the dash lasts for
@export var dash_time: float = 0.2
## What speed you dash at
@export var dash_speed: float = 600
var decel_rate: float

func enter():
	if (Input.is_action_pressed("down")):
		player.velocity.y = dash_speed
		#player.velocity.x = 0
	else:
		player.velocity.x = dash_speed * player.facing_dir
		player.velocity.y = 0
	#decel_rate = absf(player.velocity.x / stopping_time)
	get_tree().create_timer(dash_time).timeout.connect(on_dash_timeout)
	
	
func physics_update(delta: float):
	player.move_and_slide()


func on_dash_timeout():
	player.has_dash = false
	transitioned.emit(self, "PlayerMoveState")
