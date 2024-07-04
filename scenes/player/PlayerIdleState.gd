extends PlayerState
class_name PlayerGroundedState

## STATE: when the player is grounded and is not inputting any controls

func enter():
	player.has_dash = true
	player.has_double_jump = true
	pass

func exit():
	pass

func update(_delta: float):
	pass
	
func physics_update(delta: float):
	friction_x(delta)
	apply_gravity(delta)
	player.move_and_slide()
	
	if (Input.get_axis("left", "right")):
		transitioned.emit(self, "PlayerMoveState")
	elif (jump()):
		transitioned.emit(self, "PlayerJumpState")
	elif (dash()):
		transitioned.emit(self, "PlayerDashState")
