extends PlayerState
class_name PlayerJumpState

@export var jump_force: int = -600
@export_range(0, 1.0) var jump_apex_mult: float = 0.7
@export_range(1, 3) var jump_release_mult: float = 2
var curr_dir: float = 0
var peak_reached: bool = false
var jump_released: bool = false

func enter():
	player.velocity.y = jump_force
	curr_dir = signf(player.velocity.x)
	peak_reached = false
	jump_released = false

func physics_update(delta: float):
	if (player.is_on_floor()):
		transitioned.emit(self, "PlayerIdleState")

	if (Input.get_axis("left", "right")):
		move_x(delta, 0.7)
	else:
		friction_x(delta, curr_dir, 0.2)
	#move_x(delta, 0.5)
	#friction_x(delta, curr_dir, decel_rate)
	
	if (!jump_released and !Input.is_action_pressed("jump")):
		jump_released = true
	
	# update jump peak reached flag based on y velocity
	if (!peak_reached):
		peak_reached = player.velocity.y > 0
	else:
		peak_reached = player.velocity.y < 100
	
	# apply gravity multiplier after jump peak is reached
	var _release_mult = jump_release_mult if jump_released else 1
	if (peak_reached):
		apply_gravity(delta, jump_apex_mult * _release_mult)
	else:
		apply_gravity(delta, _release_mult)
	
	player.move_and_slide()
	
	curr_dir = signf(player.velocity.x)


#func check_grounded():
	#if (player.is_on_floor()):
		#transitioned.emit(self, "PlayerIdleState")
