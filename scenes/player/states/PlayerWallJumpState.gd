extends PlayerState
class_name PlayerWallJumpState

## STATE: when the player performs a wall jump.
## While in this state, the player has no control for the duration of wall_jump_time
## Afterwards, automatically transition back into MoveState



@export_range(0, 1.0) var wall_jump_time: float = 0.1
## Percentage of current move speed to add on to vertical wall jump vel
## so higher speeds mean slightly higher jumps for better game feel
@export_range(0, 1.0) var wall_jump_vel_speed_mult: float = 0.2


func exit_wall_jump():
	player.wall_jump_grace_timer.stop()
	transitioned.emit(self, "PlayerMoveState")

func enter():
	AudioManager.wall_jump_sfx.play()
	
	player.jump_buffer_timer.stop()
	get_tree().create_timer(wall_jump_time).timeout.connect(exit_wall_jump)
	player.velocity.y = player.wall_jump_vel - (player.move_speed * wall_jump_vel_speed_mult)
	player.velocity.x = player.move_speed * player.get_wall_normal().x

func physics_update(_delta: float):
	player.move_and_slide()
	
