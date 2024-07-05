extends PlayerState
class_name PlayerWallState

## STATE: when the player is sliding on a wall

@export var wall_slide_speed: int = 300
@export var wall_slide_accel: int = 200

func enter():
	player.velocity.y = 0

func physics_update(delta: float):
	
	player.velocity.y = Calc.approach(player.velocity.y, wall_slide_speed, wall_slide_accel * delta)
	player.move_and_slide()
	
	if wall_jump():
		transitioned.emit(self, "PlayerWallJumpState")
	elif !wall():
		transitioned.emit(self, "PlayerMoveState")
		
