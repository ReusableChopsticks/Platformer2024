extends PlayerState
class_name PlayerDoubleJumpState

@export var double_jump_force: int = -300

func enter():
	player.jump_buffer_timer.stop()
	player.has_double_jump = false
	player.velocity.y = double_jump_force
	
func physics_update(delta: float):
	# left and right movement
	if (Input.get_axis("left", "right")):
		move_x(delta, player.air_move_mult)
	else:
		friction_x(delta, player.air_friction_mult)
	
	apply_gravity(delta)		
	player.move_and_slide()
	
	
	if grounded():
		transitioned.emit(self, "PlayerMoveState")
	elif dash():
		transitioned.emit(self, "PlayerDashState")
	elif wall():
		transitioned.emit(self, "PlayerWallState")
