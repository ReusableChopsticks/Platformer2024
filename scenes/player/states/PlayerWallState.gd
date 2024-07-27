extends PlayerState
class_name PlayerWallState

## STATE: when the player is sliding on a wall

@export var wall_slide_speed: int = 300
@export var wall_slide_accel: int = 200
## The amount of time you can stay on a wall without losing speed levels
@export var speed_grace_time: float = 0.2
## If set to true, the player loses speed if wall sliding for too long
@export var lose_speed_on_wall: bool = false

var time_elapsed: float = 0
var speed_resetted = false

func enter():
	player.last_rebound_dir = 0
	player.velocity.y = 0
	speed_resetted = false
	time_elapsed = 0

func physics_update(delta: float):
	time_elapsed += delta
	
	## reset speed once grace time is over
	if lose_speed_on_wall:
		if (not speed_resetted and time_elapsed > speed_grace_time):
			player.reset_speed_level()
			speed_resetted = true
	
	player.velocity.y = Calc.approach(player.velocity.y, wall_slide_speed, wall_slide_accel * delta)
	player.move_and_slide()
	
	if wall_jump():
		transitioned.emit(self, "PlayerWallJumpState")
	elif !wall():
		transitioned.emit(self, "PlayerMoveState")
