extends PlayerState
class_name PlayerMoveState


func enter():
	pass
	
func exit():
	pass

func physics_update(delta: float):
	if (!Input.get_axis("left", "right")):
		transitioned.emit(self, "PlayerIdleState")
	elif (Input.is_action_just_pressed("jump") and player.is_on_floor()):
		transitioned.emit(self, "PlayerJumpState")
	
	#var direction = signf(Input.get_axis("left", "right"))
	#player.velocity.x = lerpf(player.velocity.x, direction * move_speed, move_lerp)
	move_x(delta, 1)
	apply_gravity(delta)
	player.move_and_slide()
