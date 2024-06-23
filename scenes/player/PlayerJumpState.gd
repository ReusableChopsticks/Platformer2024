extends PlayerState
class_name PlayerJumpState

@export var jump_force: int = -600
@export var decel_rate: int = 800
var curr_dir = 0


func enter():
	player.velocity.y = jump_force
	curr_dir = signf(player.velocity.x)

func physics_update(delta: float):
	if (player.is_on_floor()):
		transitioned.emit(self, "PlayerIdleState")

	if (Input.get_axis("left", "right")):
		move_x(delta, 1)
	else:
		friction_x(delta, curr_dir, decel_rate)
	apply_gravity(delta)
	
	player.move_and_slide()


#func check_grounded():
	#if (player.is_on_floor()):
		#transitioned.emit(self, "PlayerIdleState")
