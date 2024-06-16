extends PlayerState
class_name PlayerMoveState

@export_range(0.0, 1.0) var move_lerp: float = 1
@export var move_speed = 1000

func enter():
	pass
	
func exit():
	pass

func physics_update(delta):
	if (!Input.get_axis("left", "right")):
		transitioned.emit(self, "PlayerIdleState")
	elif (Input.is_action_just_pressed("jump") and player.is_on_floor()):
		transitioned.emit(self, "PlayerJumpState")
	
	var direction = signf(Input.get_axis("left", "right"))
	player.velocity.x = lerpf(player.velocity.x, direction * move_speed, move_lerp)
	
	apply_gravity(delta)
	player.move_and_slide()
