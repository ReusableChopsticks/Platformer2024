extends PlayerState
class_name PlayerDoubleJumpState


## Just immediately transition back into move lol
## because thats where all the important checks for speed happen
func enter():
	player.jump_buffer_timer.stop()
	player.has_double_jump = false
	player.velocity.y = player.double_jump_vel
	transitioned.emit(self, "PlayerMoveState")
	
	AudioManager.double_jump_sfx.play()
	
#func physics_update(delta: float):
	## left and right movement
	#move_x(delta, player.air_move_mult)
	#apply_gravity(delta)		
	#player.move_and_slide()
	#
	#
	#if grounded():
		#transitioned.emit(self, "PlayerMoveState")
	#elif dash():
		#transitioned.emit(self, "PlayerDashState")
	#elif wall():
		#transitioned.emit(self, "PlayerWallState")
