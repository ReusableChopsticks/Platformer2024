extends PlayerState
class_name PlayerJumpState

@export var jump_force: int = -600
@export var decel_rate: int = 200
var curr_dir: float = 0
var peak_reached: bool = false

func enter():
	player.velocity.y = jump_force
	curr_dir = signf(player.velocity.x)
	peak_reached = false

func physics_update(delta: float):
	if (player.is_on_floor()):
		transitioned.emit(self, "PlayerIdleState")

	if (Input.get_axis("left", "right")):
		move_x(delta, 0.4)
	else:
		friction_x(delta, curr_dir, decel_rate)
	#move_x(delta, 0.5)
	#friction_x(delta, curr_dir, decel_rate)
	
	
	if (!peak_reached):
		peak_reached = player.velocity.y > 0
	else:
		peak_reached = player.velocity.y < 100
	print(player.velocity.y)
	print(peak_reached)
	# apply gravity multiplier after jump peak is reached
	if (peak_reached):
		apply_gravity(delta, 0.7)
	else:
		apply_gravity(delta)
	
	player.move_and_slide()
	
	curr_dir = signf(player.velocity.x)


#func check_grounded():
	#if (player.is_on_floor()):
		#transitioned.emit(self, "PlayerIdleState")
