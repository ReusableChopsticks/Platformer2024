extends PlayerState
class_name PlayerReboundState

@export var rebound_time: float = 0.2

func enter():
	if player.is_on_wall():
		player.velocity.x = player.move_speed * player.get_wall_normal().x
		player.velocity.y = player.rebound_y_vel
		## increase base speed by one on rebound
		player.increment_speed_level()
	elif player.is_on_floor() and Input.is_action_pressed("down"):
		player.velocity.y = player.floor_rebound_vel
	else:
		printerr("ERROR: entered rebound state while not on wall or floor")
	
	get_tree().create_timer(rebound_time).timeout.connect(on_rebound_timeout)
	
func physics_update(delta: float):
	apply_gravity(delta)
	player.move_and_slide()

func on_rebound_timeout():
	transitioned.emit(self, "PlayerMoveState")
