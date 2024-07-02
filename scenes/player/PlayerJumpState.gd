extends PlayerState
class_name PlayerJumpState

@export var jump_force: int = -500
@export_range(0, 1.0) var jump_apex_mult: float = 0.7
@export_range(1, 3) var jump_release_mult: float = 2
@export_range(0, 1) var air_move_mult: float = 0.7
@export_range(0, 1) var air_friction_mult: float = 0.2
var is_peak_reached: bool = false
var is_jump_released: bool = false



func enter():
	# apply jump force
	player.velocity.y = jump_force
	is_peak_reached = false
	is_jump_released = false

func physics_update(delta: float):
	if (player.is_on_floor()):
		transitioned.emit(self, "PlayerIdleState")

	# left and right movement
	if (Input.get_axis("left", "right")):
		move_x(delta, air_move_mult)
	else:
		friction_x(delta, air_friction_mult)
	
	if (!is_jump_released and !Input.is_action_pressed("jump")):
		is_jump_released = true
	
	# update jump peak reached flag based on y velocity
	# apex multiplier will be applied when y velocity is above 0 and below 100
	if (!is_peak_reached):
		is_peak_reached = player.velocity.y > 0
	else:
		is_peak_reached = player.velocity.y < 100
	
	# apply gravity multiplier after jump peak is reached
	var _release_mult = jump_release_mult if is_jump_released else 1.0
	if (is_peak_reached):
		apply_gravity(delta, jump_apex_mult * _release_mult)
	else:
		apply_gravity(delta, _release_mult)
	
	player.move_and_slide()


#func check_grounded():
	#if (player.is_on_floor()):
		#transitioned.emit(self, "PlayerIdleState")
