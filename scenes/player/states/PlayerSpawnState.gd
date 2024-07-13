extends PlayerState
class_name PlayerSpawnState

func enter():
	player.reset_speed_level()

func physics_update(delta: float):
	apply_gravity(delta)
	player.move_and_slide()
	
	if grounded():
		transitioned.emit(self, "PlayerMoveState")
		#player.has_dash = true
		#player.has_double_jump = true
		
