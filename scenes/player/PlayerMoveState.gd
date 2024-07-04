extends PlayerState
class_name PlayerMoveState


func enter():
	pass
	
func exit():
	pass

func physics_update(delta: float):
	
	
	#var direction = signf(Input.get_axis("left", "right"))
	#player.velocity.x = lerpf(player.velocity.x, direction * move_speed, move_lerp)
	move_x(delta, 1)
	apply_gravity(delta)
	player.move_and_slide()
	
	if (grounded()):
		transitioned.emit(self, "PlayerGroundedState")
	elif (jump()):
		transitioned.emit(self, "PlayerJumpState")
	elif (dash()):
		transitioned.emit(self, "PlayerDashState")
