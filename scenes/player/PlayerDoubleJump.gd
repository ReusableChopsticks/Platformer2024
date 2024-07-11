extends PlayerState
class_name PlayerDoubleJumpState



func enter():
	player.jump_buffer_timer.stop()
	player.has_double_jump = false
	player.velocity.y = player.double_jump_vel
	
func physics_update(delta: float):
	# left and right movement
	move_x(delta, player.air_move_mult)
	apply_gravity(delta)		
	player.move_and_slide()
	
	
	if grounded():
		transitioned.emit(self, "PlayerMoveState")
	elif dash():
		transitioned.emit(self, "PlayerDashState")
	elif wall():
		transitioned.emit(self, "PlayerWallState")
