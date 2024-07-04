extends PlayerState
class_name PlayerMoveState

## STATE: when the player is moving either on the ground or in the air.

func enter():
	pass
	
func exit():
	pass

func physics_update(delta: float):
	if (player.is_on_floor()):
		player.has_dash = true
		move_x(delta)
	else:
		move_x(delta, player.air_friction_mult)
	apply_gravity(delta)
	player.move_and_slide()
	
	if (idle()):
		transitioned.emit(self, "PlayerIdleState")
	elif (jump()):
		transitioned.emit(self, "PlayerJumpState")
	elif (dash()):
		transitioned.emit(self, "PlayerDashState")
