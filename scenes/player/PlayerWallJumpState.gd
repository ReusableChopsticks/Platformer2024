extends PlayerState
class_name PlayerWallJumpState

## STATE: when the player performs a wall jump

@export var wall_jump_force: int = -300
@export_range(0, 1.0) var wall_jump_time: float = 0.2
#@export_range(0, 1.0) var jump_apex_mult: float = 0.7
@export_range(1, 3) var jump_release_mult: float = 2

var is_peak_reached: bool = false
var is_jump_released: bool = false
var in_uncontrolled_jump := true

func exit_uncontrolled_jump():
	in_uncontrolled_jump = false

func enter():
	in_uncontrolled_jump = true
	get_tree().create_timer(wall_jump_time).timeout.connect(exit_uncontrolled_jump)
	player.velocity.y = wall_jump_force
	player.velocity.x = wall_jump_force * -player.get_wall_normal().x

func physics_update(delta: float):
	if in_uncontrolled_jump:
		player.move_and_slide()
		return
	
	# left and right movement
	if (Input.get_axis("left", "right")):
		move_x(delta, player.air_move_mult)
	else:
		friction_x(delta, player.air_friction_mult)
	
	if Input.is_action_just_released("jump"):
		is_jump_released = true
	if is_equal_approx(player.velocity.y, 0):
		is_peak_reached = true
	
	if is_jump_released or is_peak_reached:
		apply_gravity(delta, 2)
	else:
		apply_gravity(delta)
	
	player.move_and_slide()
	
	
	if grounded():
		transitioned.emit(self, "PlayerMoveState")
	elif dash():
		transitioned.emit(self, "PlayerDashState")
	elif wall():
		transitioned.emit(self, "PlayerWallState")
