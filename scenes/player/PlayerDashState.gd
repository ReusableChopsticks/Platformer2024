extends PlayerState
class_name PlayerDashState

#@export var stopping_time: float = 0.2
@export var dash_time: float = 0.2
@export var dash_vel: float = 600
var decel_rate: float

func enter():
	has_dash = false
	
	if (Input.is_action_pressed("down")):
		player.velocity.y = dash_vel
		#player.velocity.x = 0
	else:
		player.velocity.x = dash_vel * player_facing_dir
		player.velocity.y = 0
	#decel_rate = absf(player.velocity.x / stopping_time)
	get_tree().create_timer(dash_time).timeout.connect(on_dash_timeout)
	
	
func physics_update(delta: float):
	player.move_and_slide()
	
	#print(player.velocity)
	
	
func on_dash_timeout():
	transitioned.emit(self, "PlayerMoveState")
