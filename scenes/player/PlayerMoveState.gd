extends PlayerState
class_name PlayerMoveState

# STATE: when the player is moving on the ground

func enter():
	pass
	
func exit():
	pass

func physics_update(delta: float):
	if (player.is_on_floor()):
		player.has_dash = true
	
	#var direction = signf(Input.get_axis("left", "right"))
	#player.velocity.x = lerpf(player.velocity.x, direction * move_speed, move_lerp)
	move_x(delta, 1)
	apply_gravity(delta)
	player.move_and_slide()
	
	if (idle()):
		transitioned.emit(self, "PlayerIdleState")
	elif (jump()):
		transitioned.emit(self, "PlayerJumpState")
	elif (dash()):
		transitioned.emit(self, "PlayerDashState")
