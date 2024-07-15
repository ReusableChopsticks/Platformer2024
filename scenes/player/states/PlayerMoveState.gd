extends PlayerState
class_name PlayerMoveState

## STATE: when the player is moving left or right on the ground or in the air.
## This is where grounded check happens for refilling dash / double jump charge

func enter():
	#if (player.is_on_floor()):
		#player.has_dash = true
		#player.has_double_jump = true
	pass
	
func exit():
	pass

func physics_update(delta: float):
	var move_mult = 1
	if (player.is_on_floor()):
		if !player.has_dash:
			player.has_dash = true
		if !player.has_double_jump:
			player.has_double_jump = true
	else:		
		move_mult = player.air_move_mult
	
	if idle() and player.speed_level > 1:
		player.reset_speed_level()
	## to retain speed, player must be moving in the direction of last wall rebound
	## speed is retained on wall jumps
	elif sign(player.get_wall_normal().x) != sign(player.velocity.x) and \
	  player.wall_jump_grace_timer.is_stopped() and \
	  player.speed_level > 1:
		player.reset_speed_level()
		
	
	# use appropriate multiplier depending on if player is on ground or in air
	move_x(delta, move_mult)
	apply_gravity(delta)
	player.move_and_slide()

	if jump():
		transitioned.emit(self, "PlayerJumpState")
	elif dash():
		transitioned.emit(self, "PlayerDashState")
	elif wall_jump():
		transitioned.emit(self, "PlayerWallJumpState")
	elif wall():
		transitioned.emit(self, "PlayerWallState")
	elif double_jump():
		transitioned.emit(self, "PlayerDoubleJumpState")
		
