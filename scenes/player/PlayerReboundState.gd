extends PlayerState
class_name PlayerReboundState

@export var rebound_time: float = 0.2
## y velocity to apply when rebounding off wall.
@export var rebound_y_vel: int = -200


func enter():
	if player.is_on_wall():
		player.velocity.x = player.move_speed * player.get_wall_normal().x
		player.velocity.y = rebound_y_vel
		print("wall rebound")
		## TODO: increase base speed by one on rebound
		player.increment_speed_level()
	elif player.is_on_floor() and Input.is_action_pressed("down"):
		player.velocity.y = -1000
		print("floor rebound")
	else:
		printerr("ERROR: entered rebound state while not on wall or floor")
	
	get_tree().create_timer(rebound_time).timeout.connect(on_rebound_timeout)
	
func physics_update(delta: float):
	apply_gravity(delta)
	player.move_and_slide()

func on_rebound_timeout():
	transitioned.emit(self, "PlayerMoveState")
