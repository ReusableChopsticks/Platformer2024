extends PlayerState
class_name PlayerWallJumpState

## STATE: when the player performs a wall jump.
## While in this state, the player has no control for the duration of wall_jump_time
## Afterwards, automatically transition back into MoveState

## Base vertical wall jump velocity
@export var wall_jump_vel: int = -300
## Percentage of current move speed to add on to vertical wall jump vel
## so higher speeds mean slightly higher jumps for better game feel
@export_range(0, 1.0) var wall_jump_vel_speed_mult: float = 0.2
@export_range(0, 1.0) var wall_jump_time: float = 0.1


func exit_wall_jump():
	transitioned.emit(self, "PlayerMoveState")

func enter():
	player.jump_buffer_timer.stop()
	get_tree().create_timer(wall_jump_time).timeout.connect(exit_wall_jump)
	player.velocity.y = wall_jump_vel - (player.move_speed * wall_jump_vel_speed_mult)
	player.velocity.x = player.move_speed * player.get_wall_normal().x

func physics_update(delta: float):
	player.move_and_slide()
	
