extends PlayerState
class_name PlayerGroundedState

# STATE: when the player is grounded and is not supplying any inputs

func enter():
	player.has_dash = true
	#has_double_jump = true
	pass

func exit():
	pass

func update(_delta: float):
	pass
	
func physics_update(delta: float):
	
	
	
	#player.velocity.x = lerpf(player.velocity.x, 0, 0.05)
	friction_x(delta, 1)
	apply_gravity(delta)
	player.move_and_slide()
	
	if (Input.get_axis("left", "right")):
		transitioned.emit(self, "PlayerMoveState")
	elif (jump()):
		transitioned.emit(self, "PlayerJumpState")
	elif (dash()):
		transitioned.emit(self, "PlayerDashState")
