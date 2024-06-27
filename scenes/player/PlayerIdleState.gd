extends PlayerState
class_name PlayerIdleState

var curr_dir = 0

func enter():
	curr_dir = signf(player.velocity.x)
	
func exit():
	pass

func update(_delta: float):
	pass
	
func physics_update(delta: float):
	if (Input.get_axis("left", "right")):
		transitioned.emit(self, "PlayerMoveState")
	elif (Input.is_action_just_pressed("jump") and player.is_on_floor()):
		transitioned.emit(self, "PlayerJumpState")
	
	
	#player.velocity.x = lerpf(player.velocity.x, 0, 0.05)
	friction_x(delta, 1)
	
	apply_gravity(delta)
	player.move_and_slide()

