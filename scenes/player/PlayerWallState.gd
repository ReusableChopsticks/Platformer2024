extends PlayerState
class_name PlayerWallState

## STATE: when the player is sliding on a wall

@export var wall_slide_speed: int = 100
@export var wall_slide_accel: int = 50

func enter():
	player.velocity.y = 0

func physics_update(delta: float):
	
	player.velocity.y = Calc.approach(player.velocity.y, wall_slide_speed, wall_slide_accel * delta)
	player.move_and_slide()
	
	if (!wall()):
		transitioned.emit(self, "PlayerMoveState")
