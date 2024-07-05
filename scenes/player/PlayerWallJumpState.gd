extends PlayerState
class_name PlayerWallJumpState

## STATE: when the player performs a wall jump.
## While in this state, the player has no control for the duration of wall_jump_time
## Afterwards, automatically transition back into MoveState

@export var wall_jump_force: int = -300
@export_range(0, 1.0) var wall_jump_time: float = 0.1
@export_range(1, 3) var jump_release_mult: float = 2


func exit_wall_jump():
	transitioned.emit(self, "PlayerMoveState")

func enter():
	get_tree().create_timer(wall_jump_time).timeout.connect(exit_wall_jump)
	player.velocity.y = wall_jump_force
	player.velocity.x = wall_jump_force * -player.get_wall_normal().x

func physics_update(delta: float):
	player.move_and_slide()
	
