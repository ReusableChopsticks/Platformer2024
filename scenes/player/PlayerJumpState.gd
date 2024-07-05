extends PlayerState
class_name PlayerJumpState

## STATE: includes the moment the player jumps until the time it lands
## handles jump apex gravity mod and air movement controls

@export var jump_force: int = -500
#@export_range(0, 1.0) var jump_apex_mult: float = 0.7
@export_range(1, 3) var jump_release_mult: float = 2

var is_peak_reached: bool = false
var is_jump_released: bool = false

func enter():
	# apply jump force
	player.jump_buffer_timer.stop()
	player.velocity.y = jump_force

func physics_update(delta: float):
	# left and right movement
	if (Input.get_axis("left", "right")):
		move_x(delta, player.air_move_mult)
	else:
		friction_x(delta, player.air_friction_mult)
	
	# halve velocity when releasing jump
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y /= 2
	
	apply_gravity(delta)		
	
	player.move_and_slide()
	
	
	if grounded():
		transitioned.emit(self, "PlayerMoveState")
	elif dash():
		transitioned.emit(self, "PlayerDashState")
	elif wall():
		transitioned.emit(self, "PlayerWallState")
