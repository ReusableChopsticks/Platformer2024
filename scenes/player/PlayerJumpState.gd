extends PlayerState
class_name PlayerJumpState

@export var jump_force: int = -600

func enter():
	player.velocity.y = jump_force

func physics_update(delta: float):
	#call_deferred("check_grounded")
	if (player.is_on_floor()):
		transitioned.emit(self, "PlayerIdleState")
	
	apply_gravity(delta)
	
	
	player.move_and_slide()


#func check_grounded():
	#if (player.is_on_floor()):
		#transitioned.emit(self, "PlayerIdleState")
