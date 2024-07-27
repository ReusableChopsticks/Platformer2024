extends PlayerState
class_name PlayerReboundState

@export var rebound_time: float = 0.2

func enter():
	AudioManager.rebound_sfx.play()
	
	if player.is_on_wall():
		var wall_normal = sign(player.get_wall_normal().x)
		player.last_rebound_dir = wall_normal
		player.velocity.x = player.move_speed * wall_normal
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

#func exit():
	#player.velocity.x = clampf(player.velocity.x, -player.move_speed, player.move_speed)

func on_rebound_timeout():
	transitioned.emit(self, "PlayerMoveState")
