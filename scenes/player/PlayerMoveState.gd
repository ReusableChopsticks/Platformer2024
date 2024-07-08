extends PlayerState
class_name PlayerMoveState

## STATE: when the player is moving left or right on the ground or in the air.
## This is where grounded check happens for refilling dash / double jump charge

func enter():
	pass
	
func exit():
	pass

func physics_update(delta: float):
	var move_mult = 1
	var friction_mult = 1
	if (player.is_on_floor()):
		player.has_dash = true
		player.has_double_jump = true
	else:		
		friction_mult = player.air_friction_mult
		move_mult = player.air_move_mult
	
	if idle() and player.speed_level > 1:
		player.reset_speed_level()
	
	# use appropriate multiplier depending on if player is on ground or in air
	if (Input.get_axis("left", "right")):
		move_x(delta, move_mult)
	else:
		friction_x(delta, friction_mult)
	
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
		
